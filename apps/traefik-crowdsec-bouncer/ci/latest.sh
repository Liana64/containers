#!/usr/bin/env bash

auth=()
[[ -n "${TOKEN}" ]] && auth=(-H "Authorization: Bearer ${TOKEN}")
version=$(curl -fsSL "${auth[@]}" "https://api.github.com/repos/maxlerebourg/crowdsec-bouncer-traefik-plugin/releases/latest" | jq --raw-output '.tag_name' 2>/dev/null)
[[ -z "${version}" || "${version}" == "null" ]] && exit 0
version="${version#*v}"
printf "%s" "${version}"
