#!/bin/bash
hbase_home="/application/search"
TMP_DIR="$hbase_home/tmp"

#################
if [ -d $hbase_home/zookeeper ];then
    rm -rf $hbase_home/zookeeper/logs/version-2/*
    rm -rf $hbase_home/zookeeper/zookeeper-data/version-2/*
    rm -rf $hbase_home/zookeeper/bin/zookeeper.out
else
    echo "zookeeper is not configure" >> $TMP_DIR/install_log
    exit 1
fi
