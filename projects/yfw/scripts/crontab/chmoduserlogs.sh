#!/bin/bash
# Script to chmod userlogs dir for readonly users
# Date : 2013-03-14

dir="/data0/search/hadoop-tmp/logs/userlogs/"
if [ -d $dir ]
then
    cd $dir
    chmod  755  *
    chmod  755  */attempt*
    chmod  644  */job-acls.xml
fi
