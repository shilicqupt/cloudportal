#!/usr/bin/env bash

su - search -c "/application/search/storm-0.8.2/bin/storm nimbus > /dev/null 2>&1 &"
su - search -c "/application/search/storm-0.8.2/bin/storm ui > /dev/null 2>&1 &"