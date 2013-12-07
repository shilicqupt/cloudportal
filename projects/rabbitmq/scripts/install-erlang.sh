#!/usr/bin/env bash


if [ -z "$1" ]; then
    echo " [`date`] ERROR : required <intall-dir> "  2>&1 
    exit 1
fi

DIR=$1

##############install zero mq####################
if [ ! -d $DIR ]; then
    echo " [`date`] ERROR : DIR ' $DIR' not exits "  2>&1 
fi

echo ' [`date`] INFO : cd $DIR  Install .'   2>&1

cd $DIR

./configure
make
make install

if [ $? = 0 ];then
        echo " [`date`] INFO : erlang install succeed" 
else
        echo " [`date`] ERROR : erlang  intall failed" 
fi