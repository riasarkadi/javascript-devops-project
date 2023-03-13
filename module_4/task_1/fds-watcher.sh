#!/usr/bin/env bash

get_disk_space() {
treshold=$1

if [ -z $1 ]; then
treshold="600"
fi

echo "Disk space treshold: $treshold M"

df -m | tail -n +2 | grep -vE 'tmpfs' | awk '{print $4 " " $1}' | while read output; do

space=$(echo $output | awk '{print $1}')
disk=$(echo $output | awk '{print $2}')

if (("$space" < "$treshold"))
then
    echo "Warning! Disk space is below treshold on $disk: $space M"
fi
done
}

while :; do clear; get_disk_space; sleep 2; done