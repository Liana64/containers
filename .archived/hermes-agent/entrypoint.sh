#!/usr/bin/env bash

exec \
    /opt/venv/bin/hermes \
        gateway \
        run \
        "$@"
