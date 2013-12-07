#!/bin/bash
hadoop_home="/application/search/hadoop-0.20.2-cdh3u4"
hbase_home="/application/search"
hbase_v="hbase-0.94.3"
zookeeper_v="zookeeper"
user="search"
TMP_DIR="$hbase_home/tmp"

###########################
[ -d $hadoop_home ] && [ -d $hbase_home/$hbase_v ]
if [ $? = 0 ];then
    rm -f $hbase_home/$hbase_v/lib/hadoop-core*
    cp $hadoop_home/hadoop-core-0.20.2-cdh3u4.jar $hbase_home/$hbase_v/lib/
    chown -R $user:$user $hbase_home/$hbase_v
else
    echo "hbase-0.94.3 is not configure" >> $TMP_DIR/install_log
    exit 1
fi
