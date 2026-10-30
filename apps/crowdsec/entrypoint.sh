#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
    lapi)
        : "${AGENT_PASSWORD:?}" "${BOUNCER_KEY:?}"
        cscli machines add lapi --auto --force --url http://127.0.0.1:8080 --file /tmp/local_api_credentials.yaml
        cscli machines add agent --password "${AGENT_PASSWORD}" --force --file /dev/null
        cscli bouncers delete traefik >/dev/null 2>&1 || true
        cscli bouncers add traefik --key "${BOUNCER_KEY}" >/dev/null
        exec crowdsec -no-cs
        ;;
    agent)
        : "${AGENT_PASSWORD:?}" "${LAPI_URL:?}"
        yq -n '.url = strenv(LAPI_URL) | .login = "agent" | .password = strenv(AGENT_PASSWORD)' \
            > /tmp/local_api_credentials.yaml
        exec crowdsec -no-api
        ;;
    *)
        exec "${@:?usage: lapi | agent | <command>}"
        ;;
esac
