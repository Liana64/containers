#!/usr/bin/env bash

set -e

config=/cryptpad/config/config.js

if [[ ! -f "${config}" && -n "${CPAD_MAIN_DOMAIN}" ]]; then
    sed \
        -e "s@\(httpUnsafeOrigin:\).*[^,]@\1 '${CPAD_MAIN_DOMAIN}'@" \
        -e "s@\(^ *\).*\(httpSafeOrigin:\).*[^,]@\1\2 '${CPAD_SANDBOX_DOMAIN:?CPAD_SANDBOX_DOMAIN is required with CPAD_MAIN_DOMAIN}'@" \
        /cryptpad/config/config.example.js > "${config}"
fi

node scripts/build.js

exec \
    node server.js \
    "$@"
