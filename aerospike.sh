#!/bin/bash

# add multicast
#ifconfig eth0 multicast
#ip route add 224.0.0.0/4 dev eth0

# configure total max size of all single shared memory segments
mem=`/sbin/sysctl -n kernel.shmall`
min=4294967296
if [ "$mem" -lt $min ]
then
  echo "kernel.shmall too low, setting to 4G pages"
  /sbin/sysctl -w kernel.shmall=$min
fi

# configure max size of a single shared memory segment
mem=`/sbin/sysctl -n kernel.shmmax`
min=1073741824
if [ "$mem" -lt $min ]
then
  echo "kernel.shmmax too low, setting to 1GB"
  /sbin/sysctl -w kernel.shmmax=$min
fi

# start process
/usr/bin/asd --foreground $@