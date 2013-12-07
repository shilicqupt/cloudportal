#!/bin/bash
# Date : 2012-11-05
#set -x

if [ $# -ne 6 ]; then
  echo "usage: MODName DIR User Readonly Hostallow Iduser"
  exit 1
fi

########### Init ###############
MODName="test1-server"
DIR="/root/test/data1/"
User="zhukejun"
Readonly="no"
Hostallow="10.10.0.0/16"
Iduser="search"

MODName="$1"
DIR="$2"
User="$3"
Readonly="$4"
Hostallow="$5"
Iduser="$6"



########### Get IP ###############
IP=`/sbin/ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | grep "10.10" |cut -d: -f2 | awk '{ print $1}' | head -n1`

########### test rsync ##############
TestRsync(){

  flag=0
  flag=`cat /etc/passwd|grep ^${Iduser}:|wc -l`
  if [ $flag -eq 0 ]; then
     hstr=`hostname`
     echo $hstr" have no ${Iduser} user "
     exit 1
  fi

if [ -f /etc/rsyncd.conf ]
then
   echo "$IP : rsyncserver has been done ! "
   flag=0
   flag=`grep "\[${MODName}\]" /etc/rsyncd.conf|wc -l`
   if [ $flag -gt 0 ]; then
     echo "[${MODName}] already have,please change name"
     exit 1
   fi
   cat >>/etc/rsyncd.conf << EOF

[${MODName}]
path=${DIR}
uid=${Iduser}
gid=${Iduser}
comment=${User}
read only=${Readonly}
hosts allow=${Hostallow}
EOF
if [ ! -d $DIR ]
then
   mkdir -p $DIR
   chown ${Iduser}.${Iduser} $DIR
fi

service xinetd restart > /dev/null

if [ $? == 0 ]
then
   echo "$IP : succeed !"
else
   echo "$IP : failed !"
fi

   exit 0
fi
}
TestRsync

########### install xinetd #########
InstallXinetd(){
rpm -q xinetd
if [ $? != 0 ]
then
    yum -y install xinetd
fi
}
InstallXinetd


########### config ##################
Config(){
cat > /etc/xinetd.d/rsync << EOF
# default: off
# description: The rsync server is a good addition to an ftp server, as it \
#       allows crc checksumming etc.
service rsync
{
        disable = no
        socket_type     = stream
        wait            = no
        user            = root
        server          = /usr/bin/rsync
        server_args     = --daemon
        log_on_failure  += USERID
}
EOF
cat > /etc/rsyncd.conf << EOF
uid=search
gid=search
max connections=100
pid file=/var/run/rsyncd.pid
lock file=/var/run/rsyncd.lock
log file=/var/log/rsyncd.log
timeout=60

[${MODName}]
path=${DIR}
uid=${Iduser}
gid=${Iduser}
comment=${User}
read only=${Readonly}
hosts allow=${Hostallow}
EOF
}
Config

if [ ! -d $DIR ]
then
   mkdir -p $DIR
   chown ${Iduser}.${Iduser} $DIR
fi

######### restart service #############
service xinetd restart > /dev/null
if [ $? == 0 ]
then
   echo "$IP : succeed !"
else
   echo "$IP : failed !"
fi