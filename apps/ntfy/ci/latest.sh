#!/usr/bin/env bash

channel=$1
auth=()
[[ -n "${TOKEN}" ]] && auth=(-H "Authorization: Bearer ${TOKEN}")
version=$(curl -fsSL "${auth[@]}" "https://api.github.com/repos/binwiederhier/ntfy/releases/latest" | jq --raw-output '.tag_name' 2>/dev/null)
[[ -z "${version}" || "${version}" == "null" ]] && exit 0
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
