#!/usr/bin/env bash

version=$(curl -fsSL "https://forgejo.ellis.link/api/v1/repos/continuwuation/continuwuity/releases/latest" | jq --raw-output '.tag_name' 2>/dev/null)
[[ -z "${version}" || "${version}" == "null" ]] && exit 0
version="${version#*v}"
printf "%s" "${version}"
