#!/bin/bash

while [ -n "$1" ];do
  if [ ! -f /etc/host-location-map ]; then
    racks=(${racks[@]} "/default-rack")
    shift
    continue
  fi

  location=`awk '/'"$1"'/{print $1;exit}' /etc/host-location-map`
  location=`echo $location | sed 's/[[:blank:]]//g'`
  if [ "$location" = "" ];then
    racks=(${racks[@]} "/default-rack")
    shift
    continue
  fi
  rack=`echo $location | awk -F\- '{print $2}'`
  rack=`echo $rack | sed 's/[[:blank:]]//g'`
  if [ "$rack" = "" ];then
    racks=(${racks[@]} "/default-rack")
    shift
    continue
  fi
  racks=(${racks[@]} "/$rack")
  shift
done

echo ${racks[@]}
