#!/usr/bin/env bash
set -e

umask "${UMASK}"

if [ -w "${HOME}" ]; then
    mkdir -p "${HOME}/.ssh"
    chmod 0700 "${HOME}/.ssh"
    find "${HOME}/.ssh" -maxdepth 1 -type f ! -name '*.pub' ! -name 'known_hosts' \
        -exec chmod 0600 {} + 2>/dev/null || true
fi

if [ $# -eq 0 ]; then
    if [ -t 0 ]; then
        exec codex
    else
        echo "Container running. Use 'kubectl exec' to access Codex."
        exec tail -f /dev/null
    fi
else
    exec "$@"
fi
