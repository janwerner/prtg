#! /usr/bin/env bash

MD=$1

STATE=$(mdadm --detail /dev/${MD} | grep -oP 'State : \K.+' | sed 's: ::g')

if [[ $STATE =~ ^(clean|active)$ ]]; then
  echo "0:0:Software RAID state: ${STATE}"
else
  echo "2:0:Software RAID state: ${STATE}"
fi

