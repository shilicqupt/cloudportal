#!/usr/bin/env bash

LOG_DIR="/tmp"
touch $LOG_DIR/install_log

for d in /dev/sd[b-z]1;
do
   tune2fs -m 3 $d
   echo " [`date`] INFO :   tune2fs -m 3 $d"  2>&1 | tee  -ai $LOG_DIR/install_log
done