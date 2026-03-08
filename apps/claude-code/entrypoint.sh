#!/usr/bin/env bash
set -e

if [ $# -eq 0 ]; then
    if [ -t 0 ]; then
        exec claude
    else
        echo "Container running. Use 'kubectl exec' to access Claude Code."
        exec tail -f /dev/null
    fi
else
    exec "$@"
fi
