#!/usr/bin/env bash

ps -a | grep -v grep | grep supervisor > /dev/null
supervisor_result=$?
if [ "${supervisor_result}" -eq "0" ]; then
        ps aux | grep supervisor | grep -v grep | awk '{print $2}' | xargs kill -9 > /dev/null 2>&1
fi