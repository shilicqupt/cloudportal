#!/usr/bin/env bash


if [ -z "$1" ]; then
    echo " [`date`] ERROR : required <zero-mq-ver-dir> "  2>&1 
    exit 1
fi

ZERO_MQ_DIR=$1

##############install zero mq####################
if [ ! -d $ZERO_MQ_DIR ]; then
    echo " [`date`] ERROR : DIR ' $ZERO_MQ_DIR' not exits "  2>&1 
fi

echo ' [`date`] INFO : cd $ZERO_MQ_DIR  Install "lzo".'   2>&1

cd $ZERO_MQ_DIR

./configure
make
make install

if [ $? = 0 ];then
        echo " [`date`] INFO : zero mq install succeed" 
else
        echo " [`date`] ERROR : zero mq intall failed" 
fi