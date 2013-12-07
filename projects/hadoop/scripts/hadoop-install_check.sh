#!/bin/bash
#Hadoop deployment check ......##################

touch /home/borqs/check_hadoop.log
CHECK="/home/borqs"
echo "`date +"%Y-%m-%d %H:%M:%S"`" |tee -ai $CHECK/check_hadoop.log

#crontab check#

check_crontab ()
{
	if [ -f /home/borqs/crontab/$1 ];then
		echo "$1 copy is ok" |tee -ai $CHECK/check_hadoop.log
	else
		echo "please check $1" |tee  -ai $CHECK/check_hadoop.log
	fi
}
check_crontab chmodcore.sh
check_crontab chmoduserlogs.sh
check_crontab corefile_clear.sh

grep -E "chmodcore.sh|chmoduserlogs.sh|corefile_clear.sh" /var/spool/cron/root >> /dev/null 
if [ $? = 0 ];then
	echo "crontab cron is configured" |tee -ai $CHECK/check_hadoop.log
else
	echo "please check crontab cron" |tee -ai $CHECK/check_hadoop.log
fi
#crontab check end......#################################################################

#hadoop service check#
/sbin/chkconfig --list|grep hadoop >> /dev/null
if [ $? = 0 ];then
	echo "hadoop service is configured"  |tee -ai $CHECK/check_hadoop.log
else
	echo "please check hadoopo service ..."    |tee -ai $CHECK/check_hadoop.log
fi

#hadoop service check end......##########################################################

#hadoop directory check#
if [ -d /application/search/hadoop-0.20.2-cdh3u4 ];then
     echo "hadoop-0.20.2-cdh3u4 is installed" 2>&1 |tee -ai $CHECK/check_hadoop.log
else
     echo "please check hadoop directory copy" 2>&1 |tee -ai $CHECK/check_hadoop.log
fi
#hadoop directory check end...###########################################################

#kernel.core_pattern check#
cat /etc/sysctl.conf |grep "kernel.core_pattern" > /dev/null 2>&1
if [ $? = 0 ];then
      echo "kernel.core_pattern is configured" 2>&1 |tee -ai $CHECK/check_hadoop.log
else
      echo "please check kernel.core_pattern" 2>&1 |tee -ai $CHECK/check_hadoop.log
fi
#kernel.core_pattern check end......#####################################################

#hugepage permanent check#
grep "hugepage" /var/spool/cron/root >> /dev/null
if [ $? = 0 ];then
     echo "defrag is configured" 2>&1 |tee -ai $CHECK/check_hadoop.log    
else 
     echo "please check hugepage" 2>&1 |tee -ai $CHECK/check_hadoop.log
fi
#hugepage permanent check end......#####################################################

#hadoop profile check#

cat /etc/profile |grep "HADOOP_HOME" >> /dev/null
if [ $? = 0 ];then
	echo "/etc/profile/HADOOP_HOME is configured" |tee -ai $CHECK/check_hadoop.log
else
	echo "please check profile" |tee -ai $CHECK/check_hadoop.log
fi
#hadoop profile check end.....#########################################################

#lzo check#
  
/sbin/ldconfig -p |grep lzo >/dev/null 2>&1 && /sbin/ldconfig -v |grep lzo >/dev/null 2>&1
if [ $? = 0 ];then
	echo "lzo is installed" |tee -ai $CHECK/check_hadoop.log
else
	echo "please check lzo" |tee -ai $CHECK/check_hadoop.log
fi
#lzo check end......###################################################################

#protobuf check#

/sbin/ldconfig -p |grep protobuf >/dev/null 2>&1
if [ $? = 0 ];then
	echo "protobuf is installed" |tee -ai $CHECK/check_hadoop.log
else     
	echo "please check protobuf" |tee -ai $CHECK/check_hadoop.log
fi
#protobuf check end......##############################################################

#.bashrc check#

cat /application/search/.bashrc |grep "HADOOP_CONF_DIR" >> /dev/null
if [ $? = 0 ];then
	echo "bashrc is configuration" |tee -ai $CHECK/check_hadoop.log
else
	echo "please check bashrc" |tee -ai $CHECK/check_hadoop.log
fi
#.bashrc check end......##############################################################

#libhdfs.so check#

[ -h $HADOOP_HOME/c++/lib/libhdfs.so.0 ]
if [ $? = 0 ];then
	echo "libhdfs.so.0 is configuration" |tee -ai $CHECK/check_hadoop.log
else
	echo "please check libhdfs.so.0" |tee -ai $CHECK/check_hadoop.log
fi

cat /etc/ld.so.conf.d/hadoop.conf |grep "hadoop-0.20.2-cdh3u4" >> /dev/null
if [ $? = 0 ];then
	echo "hadoop.conf is configuration" 2>&1 | tee -ai $CHECK/check_hadoop.log
else
	echo "please check hadoop.conf"
fi
#libhdfs.so check end......############################################################

#host-location-map check#
IP=$(/sbin/ifconfig |grep "inet addr" |grep -v "127.0.0.1" |awk '{print $2}' |cut -d: -f2)

cat /etc/host-location-map |grep "$IP"
if [ $? = 0 ];then
    echo "host-location-map is configuration" 2>&1 | tee -ai $CHECK/check_hadoop.log
else
    echo "please check host-location-map" 2>&1 | tee -ai $CHECK/check_hadoop.log
fi
#host-location-map check end......###################################################
