# Copyright (c) 2013 AnsibleWorks, Inc.
#
# This file is part of Ansible Commander.
#
# Ansible Commander is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3 of the License.
#
# Ansible Commander is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible Commander. If not, see <http://www.gnu.org/licenses/>.

import cStringIO
import logging
import os
import select
import subprocess
import time
import traceback
from celery import Task
from django.conf import settings
import pexpect
from django.core import urlresolvers
from desktop.apps.ansible.models import *
from desktop.apps.ansible.path_utils import *
from desktop.apps.account.models import Profile
from desktop.core.lib.exceptions_renderable import PopupException

LOG = logging.getLogger(__name__)

__all__ = ['RunJob']

logger = logging.getLogger(__name__)

def get_profile(job_pk):
    job = Job.objects.get(pk=job_pk)
    user = job.created_by
    try:
        profile = Profile.objects.get(user = user)
    except:
        raise PopupException('you need to set credential, if you want to execute the task, you need to paste your  SSH Password,  SSH Pub Keys (DSA)')
    return profile

class BuildJob:

    def __init__(self, job):
        self.job = job


    def get_path_to(self, *args):
        '''
        Return absolute path relative to this file.
        '''
        return os.path.abspath(os.path.join(os.path.dirname(__file__), *args))

    def build_env(self, job, **kwargs):
        '''
        Build environment dictionary for ansible-playbook.
        '''
        env = dict(os.environ.items())
        # question: when running over CLI, generate a random ID or grab next, etc?
        # answer: TBD
        env['ANSIBLE_JOB_ID'] = str(job.pk)
        return env

    def build_args(self, job, **kwargs):

        profile = get_profile(job.pk)
        ssh_key = profile.ssh_key
        user = profile.user.username

        args = ['ansible-playbook', '-i', job.inventory]
        args.append(job.playbook)
        if job.limit:
            args.append('--limit')
            args.append(job.limit)
        if job.forks:
            args.append('-f')
            args.append(str(job.forks))
        if job.use_sudo and job.sudo_password:
            args.append('--sudo')
            args.append('--ask-sudo-pass')
        elif job.use_sudo:
            args.append('--sudo')

        args.append('--private-key')
        credential_file = create_credential_file(profile.user.username, ssh_key)
        args.append(credential_file)
        args.append('--ask-pass')

        LOG.info(" ".join(args))



        return args

    def build_passwords(self, job, **kwargs):
        '''
        Build a dictionary of passwords for SSH private key, SSH user and sudo.
        '''
        return {}

    def build(self, **kwargs):
        args = self.build_args(self.job, **kwargs)
        cwd = get_project_dir(self.job.project.name)
        env = self.build_env(self.job, **kwargs)
        passwords = self.build_passwords(self.job, **kwargs)
        return args, cwd, env, passwords


class RunJob(Task):
    '''
    Celery task to run a job using ansible-playbook.
    '''

    name = 'run_job'

    def update_job(self, job_pk, **job_updates):
        '''
        Reload Job from database and update the given fields.
        '''
        job = Job.objects.get(pk=job_pk)
        if job_updates:
            for field, value in job_updates.items():
                setattr(job, field, value)
            job.save(update_fields=job_updates.keys())
        return job

    def run_pexpect(self, job_pk, args, cwd, env, passwords):
        '''
        Run the job using pexpect to capture output and provide passwords when
        requested.
        '''
        status, stdout, stderr = 'error', '', ''
        logfile = cStringIO.StringIO()
        logfile_pos = logfile.tell()
        child = pexpect.spawn(args[0], args[1:], cwd=cwd, env=env)
        child.logfile_read = logfile
        job_canceled = False
        while child.isalive():
            expect_list = [
                r'Enter passphrase for .*:',
                r'Bad passphrase, try again for .*:',
                r'sudo password.*:',
                r'SSH password:',
                pexpect.TIMEOUT,
                pexpect.EOF,
            ]
            result_id = child.expect(expect_list, timeout=2)
            if result_id == 0:
#                child.sendline(passwords.get('ssh_unlock_key', ''))
                profile = get_profile(job_pk)
                child.sendline(profile.ssh_password)
            elif result_id == 1:
                child.sendline('')
            elif result_id == 2:
                child.sendline(job.sudo_password)
            elif result_id == 3:
#                child.sendline(passwords.get('ssh_password', ''))
                profile = get_profile(job_pk)
                child.sendline(profile.ssh_password)
            job_updates = {}
            if logfile_pos != logfile.tell():
                job_updates['result_stdout'] = logfile.getvalue()
            job = self.update_job(job_pk, **job_updates)
            if job.cancel_flag:
                child.close(True)
                job_canceled = True
        if job_canceled:
            status = 'canceled'
        elif child.exitstatus == 0:
            status = 'successful'
        else:
            status = 'failed'
        stdout = logfile.getvalue()
        return status, stdout, stderr

    def run(self, job_pk, **kwargs):
        '''
        Run the job using ansible-playbook and capture its output.
        '''
        print '1111111111111111111'
        job = self.update_job(job_pk, status='running')
        try:
            status, stdout, stderr, tb = 'error', '', '', ''
            args, cwd, env, passwords = BuildJob(job).build()
            status, stdout, stderr = self.run_pexpect(job_pk, args, cwd, env, passwords)
            print status, stdout, stderr
            print '****************************'
        except Exception:
            tb = traceback.format_exc()
        self.update_job(job_pk, status=status, result_stdout=stdout,
                        result_stderr=stderr, result_traceback=tb)
