#!/usr/bin/env bash

token=$(curl -fsSL "https://ghcr.io/token?scope=repository:mendhak/http-https-echo:pull" | jq --raw-output '.token')
version=$(curl -fsSL -H "Authorization: Bearer ${token}" "https://ghcr.io/v2/mendhak/http-https-echo/tags/list?n=10000" \
    | jq --raw-output '[.tags[] | select(test("^[0-9]+$")) | tonumber] | max' 2>/dev/null)
[[ -z "${version}" || "${version}" == "null" ]] && exit 0
printf "%s" "${version}"
