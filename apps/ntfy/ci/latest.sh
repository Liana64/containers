#!/usr/bin/env bash

channel=$1
version=$(curl -sX GET "https://api.github.com/repos/binwiederhier/ntfy/releases/latest" | jq --raw-output '. | .tag_name' 2>/dev/null)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
