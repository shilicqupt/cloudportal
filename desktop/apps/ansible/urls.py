from django.conf.urls import patterns, url
from desktop.core.lib.django_util import get_name_re_rule,get_id_re_rule
from desktop.apps.ansible.elfinder.views import ElfinderConnectorView
name_re = get_name_re_rule()
id_re=get_id_re_rule()

urlpatterns = patterns('',
    url(r'^(?P<project_name>.+)/connector/(?P<optionset>.+)/(?P<start_path>.+)/$',ElfinderConnectorView.as_view(),name='ElfinderConnector')
)

urlpatterns += patterns('desktop.apps.ansible.views',

    url(r'^(?P<project_name>%s)/template/save$' % name_re,'save_template',name='save_template'),
    url(r'^(?P<project_name>%s)/template/delete' % name_re,'delete_template',name='delete_template'),

    # projects vice
    url(r'^$','list_projects',name='list_projects'),
    url(r'^add$','edit_project', name='add_project'),
    url(r'^(?P<project_name>%s)/files/(?P<path>.+)' % name_re,'elfinder_view_file',name='elfinder_view_file'),
    url(r'^(?P<project_name>%s)/file/(?P<type>%s)/(?P<path>.+)' % (name_re,name_re),'view_file',name='view_file'),
    url(r'^(?P<project_name>%s)/explore' % name_re,'explore',name='explore'),
    url(r'^(?P<project_name>%s)/delete' % name_re,'delete_project',name='delete_project'),



    url(r'^(?P<project_name>%s)/execute/playbook/(?P<template_pk>%s)$' % (name_re,id_re),'execute_playbook',name='execute_playbook_template'),
    url(r'^(?P<project_name>%s)/execute/playbook$' % name_re,'execute_playbook',name='execute_playbook'),
    url(r'^(?P<project_name>%s)/execute/script$' % name_re,'execute_script',name='execute_script'),
    url(r'^(?P<project_name>%s)/execute/scp$' % name_re,'execute_scp',name='execute_scp'),


    url(r'^(?P<project_name>%s)/result_json/(?P<job_pk>%s)$' % (name_re,id_re),'result_json',name='job_result_json'),
    url(r'^(?P<project_name>%s)/restart/(?P<job_pk>%s)$' % (name_re,id_re),'restart_job',name='restart_job'),
    url(r'^(?P<project_name>%s)/result/(?P<job_pk>%s)$' % (name_re,id_re),'result',name='job_execute_result'),
    url(r'^(?P<project_name>%s)/logs$' % name_re,'view_project_logs',name='view_project_logs'),
    url(r'^(?P<project_name>%s)/$' % name_re,'view_project',name='view_project'),


)



