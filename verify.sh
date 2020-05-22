#!/usr/bin/env bash
required_files=( "_files" "install.sh" "start.sh" )

echo "Checking required files exist (will take ownership)..."

for i in "${required_files[@]}"
do
    if [ -f $i ]; then
        chmod +x $i
        continue
    fi

    if [ -d $i ]; then
        chown -R tf2server $i
        continue
    fi

    echo File/directory $i does not exist!
    exit 1
done

mkdir serverfiles
echo Created server file directory.