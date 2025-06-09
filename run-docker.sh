#!/usr/bin/env bash

docker build -t lua-busted .

docker run --rm -t lua-busted /data/run-tests.sh
