#!/bin/zsh
if [ $# -eq 0 ]; then
    if [ -t 0 ]; then
        exec /bin/zsh
    else
        echo "Container running. Use 'kubectl exec' to access shell."
        exec tail -f /dev/null
    fi
else
    exec "$@"
fi
