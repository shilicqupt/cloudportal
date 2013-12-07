#!/bin/bash
# clear 1 day ago corefile 
# /tmp/corefile
if [ -d /tmp/corefile ]
   then
   /usr/bin/find /tmp/corefile/ -name "core.*" -mtime +1 -exec rm -rf {} \;
   else
   exit 0
fi
