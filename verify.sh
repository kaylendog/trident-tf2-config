#!/usr/bin/env bash
required_files=( "_files" "install.sh" "start.sh" )

for i in "${required_files[@]}"
do
    if [ -f $i ]; then
        echo $i
        continue
    fi

    if [ -d $i ]; then
        echo $i
        continue
    fi

    echo File/directory $i does not exist!
    exit 1
done