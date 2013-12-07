#!/usr/bin/env bash

#SERVICE=$1
#
#ps -a | grep -v grep | grep $1 > /dev/null
#result=$?
#echo "exit code: ${result}"
#if [ "${result}" -eq "0" ] ; then
#    echo "`date`: $SERVICE service running, everything is fine"
#else
#    echo "`date`: $SERVICE is not running"
#fi

ps -a | grep -v grep | grep core > /dev/null
core_result=$?
if [ "${core_result}" -eq "0" ]; then
	ps aux | grep core | grep -v grep | awk '{print $2}' | xargs kill -9 > /dev/null 2>&1
fi

ps -a | grep -v grep | grep nimbus > /dev/null
nimbus_result=$?
if [ "${nimbus_result}" -eq "0" ]; then
	ps aux | grep nimbus | grep -v grep | awk '{print $2}' | xargs kill -9 > /dev/null 2>&1
fi