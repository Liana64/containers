#!/usr/bin/env bash

set -e

node scripts/build.js

exec \
    node server.js \
    "$@"
