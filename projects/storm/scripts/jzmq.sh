#!/usr/bin/env bash


if [ -z "$1" ]; then
    echo " [`date`] ERROR : required jzmq dir "  2>&1 
    exit 1
fi

JZMQ_DIR=$1

##############install zero mq####################
if [ ! -d $JZMQ_DIR ]; then
    echo " [`date`] ERROR : DIR ' $JZMQ_DIR' not exits "  2>&1 
fi

echo ' [`date`] INFO : cd $JZMQ_DIR  Install "jzmq".'   2>&1

#export CPPFLAGS=-I/application/search/zeromq-3.2.3/include/

cd $JZMQ_DIR
./autogen.sh
./configure
make
make install

if [ $? = 0 ];then
        echo " [`date`] INFO : jzmq install succeed" 
else
        echo " [`date`] ERROR : jzmq intall failed" 
fi