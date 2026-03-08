#!/usr/bin/env bash

version=$(curl -sX GET "https://registry.npmjs.org/@anthropic-ai/claude-code/latest" | jq --raw-output '.version')
version="${version#*v}"
printf "%s" "${version}"
