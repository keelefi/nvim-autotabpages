#!/usr/bin/env bash

set -e

# run lua-language-server
lua-language-server --configpath .luarc-ci.json --check . --checklevel=Hint

# run busted
busted --pattern="test-.*%.lua" tests
