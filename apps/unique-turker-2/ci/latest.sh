#!/usr/bin/env bash

git clone --quiet https://github.com/isaiasghezae/unique-turker-2.git /tmp/app
pushd /tmp/app > /dev/null || exit
version=$(git rev-list --count --first-parent HEAD)
popd > /dev/null || exit
rm -rf /tmp/app
printf "1.0.%d" "${version}"
