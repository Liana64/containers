#!/usr/bin/env bash

exec \
    /app/bin/picoclaw \
        gateway \
        --allow-empty \
        "$@"
