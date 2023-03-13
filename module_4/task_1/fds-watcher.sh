#!/usr/bin/env bash

get_disk_space() {
threshold=$1

if [ -z $1 ]; then
threshold="600"
fi

echo "Disk space threshold: $threshold M"

df -m | tail -n +2 | grep -vE 'tmpfs' | awk '{print $4 " " $1}' | while read output; do

space=$(echo $output | awk '{print $1}')
disk=$(echo $output | awk '{print $2}')

if (("$space" < "$threshold"))
then
    echo "Warning! Disk space is below threshold on $disk: $space M"
fi
done
}

while :; do clear; get_disk_space $1; sleep 2; done