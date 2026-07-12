#!/usr/bin/env bash

channel=$1
version=$(curl -sX GET "https://pypi.org/pypi/hermes-agent/json" | jq --raw-output '.info.version' 2>/dev/null)
version="${version#*v}"
printf "%s" "${version}"
