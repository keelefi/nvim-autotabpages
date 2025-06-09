#!/usr/bin/env bash

#CWD=$(pwd)
#export LUA_PATH="${CWD}/lua"

#busted tests/test-filepatterns.lua
busted --lpath=/data/lua/?.lua --pattern="test-.*%.lua" tests
