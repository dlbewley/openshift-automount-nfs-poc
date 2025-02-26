#!/bin/bash

#echo Trying to write to data to an automounted volume
#echo $(date) Hello from $HOSTNAME >> /mnt/automount/dallas/$HOSTNAME

ls /mnt/automount/dallas
ls /mnt/automount/tucson
ls /mnt/automount/sandiego
df -h -t nfs
sleep infinity
