#!/usr/bin/env bash

LOG_DIR="/tmp"
touch $LOG_DIR/install_log

/sbin/ldconfig -p |grep libprotobuf.so.7 && /sbin/ldconfig -v |grep libprotobuf.so.7
if [ $? = 0 ];then
        echo " [`date`] INFO :  libprotobuf.so.7  is already installed"  2>&1 | tee  -ai $LOG_DIR/install_log
	exit 0
fi


if [ -z "$1" ]; then
   echo " [`date`] ERROR : required <libprotobuf-ver-dir> "  2>&1  | tee  -ai $LOG_DIR/install_log
   exit 1
fi


PROTOBUF_DIR=$1

##############install libprotobuf####################

#cd $PROTOBUF_DIR

#if [ ! -d $LZO_DIR ]; then	
#   echo " [`date`] ERROR : DIR ' $PROTOBUF_DIR ' not exits "  2>&1  | tee  -ai $LOG_DIR/install_log
#fi

#echo ' [`date`] INFO : cd $PROTOBUF_DIR  Install "lzo".'   2>&1 | tee -ai $LOG_DIR/install_log

cd /application/search/tmp/protobuf-2.4.1
./configure
make && make check
make install

touch /etc/ld.so.conf.d/usr_local_lib.conf

grep "/usr/local/lib" /etc/ld.so.conf.d/usr_local_lib.conf

if [ $? != 0 ];then
	echo "/usr/local/lib" >> /etc/ld.so.conf.d/usr_local_lib.conf
fi

/sbin/ldconfig
/sbin/ldconfig -p |grep libprotobuf.so.7 && /sbin/ldconfig -v |grep libprotobuf.so.7

if [ $? = 0 ];then
        echo " [`date`] INFO  : libprotobuf.so.7 install succeed" | tee  -ai $LOG_DIR/install_log
else
        echo " [`date`] ERROR : libprotobuf.so.7 intall failed"  | tee  -ai $LOG_DIR/install_log
fi
