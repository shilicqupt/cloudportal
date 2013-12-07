#!/bin/bash
hbase_home="/application/search"
hbase_v="hbase-0.94.3"
zookeeper_v="zookeeper"
TMP_DIR="$hbase_home/tmp"
user="search"

#############configure zookeeper##################
host=`hostname`
cat $hbase_home/zookeeper/conf/zoo.cfg |grep "$host" >/dev/null 2>&1
if [ $? = 0 ];then
    echo "configure zookeeper is starting......"  2>&1 | tee -ai $TMP_DIR/install_log
    mkdir -p $hbase_home/zookeeper/zookeeper-data
    cat $hbase_home/zookeeper/conf/zoo.cfg |grep "$host"|awk -F"=" '{print $1}'|awk -F"." '{print $2}'>$hbase_home/zookeeper/zookeeper-data/myid
    cp $hbase_home/zookeeper/conf/zoo.cfg $hbase_home/$hbase_v/conf/zoo.cfg
    chown $user:$user -R $hbase_home/zookeeper
else
    echo "Don't need configure zookeeper...." 2>&1| tee -ai $TMP_DIR/install_log
fi

