#!/bin/zsh

if [ ! -f /data/.motd_shown ]; then
    cat /etc/motd
fi


if [ $# -eq 0 ]; then
    if [ -t 0 ]; then
        exec /bin/zsh
    else
        echo "Container running in non-interactive mode. Use 'kubectl exec' to access shell."
        exec tail -f /dev/null
    fi
else
    exec "$@"
fi

