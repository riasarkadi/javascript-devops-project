#!/usr/bin/env bash

directory=$1

if [ -z $1 ]; then
directory=$PWD
fi

ls -l $directory | wc -l | while read output; do
    echo "There are $output files in $directory directory."
done