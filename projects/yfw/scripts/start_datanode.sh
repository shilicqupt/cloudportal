#!/usr/bin/env bash

su - search -c "/application/search/hadoop-0.20.2-cdh3u4/bin/hadoop-daemon.sh start datanode > /dev/null 2>&1"