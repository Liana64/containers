#!/usr/bin/env bash
channel=$1

if [[ "${channel}" == "beta" ]]; then
    git clone --quiet https://github.com/mataroa-blog/mataroa.git /tmp/app
    pushd /tmp/app > /dev/null || exit
    version=$(git rev-list --count --first-parent HEAD)
    popd > /dev/null || exit
    rm -rf /tmp/app
    printf "1.0.%d" "${version}"
fi

if [[ "${channel}" == "stable" ]]; then
    version="$(curl -sX GET "https://api.github.com/repos/mataroa-blog/mataroa/releases/latest" | jq --raw-output '.tag_name' 2>/dev/null)"
    version="${version#*v}"
    version="${version#*release-}"
    printf "%s" "${version}"
fi
