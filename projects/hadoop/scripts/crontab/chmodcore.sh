#!/bin/bash
# Script to chmod core file for readonly users
# Date : 2013-03-01

dir="/tmp/corefile"

if [ -d $dir ]
then
    chown -R search.search $dir
    cd $dir
    chmod 644 core*
fi


