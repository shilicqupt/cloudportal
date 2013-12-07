#!/bin/bash
TMP_DIR="/tmp"
mv /application/search/hadoop-0.20.2-cdh3u4/c++/lib/libhdfs.so.0.0.0.bak /application/search/hadoop-0.20.2-cdh3u4/c++/lib/libhdfs.so.0.0.0
rm -rf /application/search/hadoop-0.20.2-cdh3u4/c++/lib/libhdfs.so.0
ln -s /application/search/hadoop-0.20.2-cdh3u4/c++/lib/libhdfs.so.0.0.0 /application/search/hadoop-0.20.2-cdh3u4/c++/lib/libhdfs.so.0
chown -R search:search /application/search/hadoop-0.20.2-cdh3u4/

[ -f /etc/ld.so.conf.d/hadoop.conf ]
if [ $? != 0 ];then
    touch /etc/ld.so.conf.d/hadoop.conf |tee -ai $TMP_DIR/install_log
    cat << EOF >/etc/ld.so.conf.d/hadoop.conf
/application/search/hadoop-0.20.2-cdh3u4/c++/lib
/usr/java/default/jre/lib/amd64/server
EOF
else
    cat /etc/ld.so.conf.d/hadoop.conf |grep "hadoop-0.20.2-cdh3u4" |tee -ai $TMP_DIR/install_log && echo "hadoop.conf is ok" 2>&1 | tee -ai $TMP_DIR/install_log
fi
/sbin/ldconfig
