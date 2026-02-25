#!/usr/bin/env bash

exec \
    /app/bin/ntfy \
        serve \
        "$@"
