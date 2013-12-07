#/usr/bin/env bash
for((i=0;i<=11;i++));
do
        rm -rf /data$i/*
        chown -R hadoop.hadoop /data$i
done