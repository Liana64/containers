#!/usr/bin/env bash

version=$(curl -fsSL "https://hub.docker.com/v2/repositories/cryptpad/cryptpad/tags?page_size=100&name=version-" \
    | jq --raw-output '.results[].name | ltrimstr("version-")' 2>/dev/null \
    | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' \
    | sort -V \
    | tail -n1)
[[ -z "${version}" ]] && exit 0
printf "%s" "${version}"
