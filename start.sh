#!/usr/bin/env bash

echo Starting server...
./tf2server start
./tf2server details

echo Server started.

while :
do
  sleep 1
done
