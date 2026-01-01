#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
    echo "ERROR: Container should not run as root"
    exit 1
fi

: "${PUID:=1337}"
: "${PGID:=1337}"
: "${UMASK:=0002}"
: "${TZ:=Etc/UTC}"

umask "${UMASK}"

CONFIG_FILE="/data/config.yaml"
REGISTRATION_FILE="/data/registration.yaml"

log_info() {
    echo "[INFO] $*"
}

log_error() {
    echo "[ERROR] $*"
}

check_permissions() {
    local file="$1"
    if [[ -f "${file}" ]]; then
        local perms
        perms=$(stat -c '%a' "${file}" 2>/dev/null || stat -f '%Lp' "${file}" 2>/dev/null || echo "")
        if [[ "${perms}" =~ [0-9][0-9][4-7] ]]; then
            chmod 600 "${file}" 2>/dev/null || true
        fi
    fi
}

validate_config() {
    if [[ ! -f "${CONFIG_FILE}" ]]; then
        return 1
    fi

    if ! yq eval . "${CONFIG_FILE}" >/dev/null 2>&1; then
        log_error "Invalid YAML syntax in ${CONFIG_FILE}"
    log_info "-------"
        return 1
    fi

    return 0
}

init_config() {
    if [[ ! -f "${CONFIG_FILE}" ]]; then
        log_info "Generating configuration file..."
        if ! /usr/bin/mautrix-meta -c "${CONFIG_FILE}" -e; then
            log_error "Failed to generate configuration"
            exit 1
        fi
        chmod 600 "${CONFIG_FILE}"
        log_info "Configuration created at: ${CONFIG_FILE}"
        log_info "Edit the configuration file and restart the container"
        exit 0
    fi
}

init_registration() {
    if [[ ! -f "${REGISTRATION_FILE}" ]]; then
        log_info "Generating registration file..."
        if ! /usr/bin/mautrix-meta -g -c "${CONFIG_FILE}" -r "${REGISTRATION_FILE}"; then
            log_error "Failed to generate registration file"
            exit 1
        fi
        chmod 600 "${REGISTRATION_FILE}"
        log_info "Registration file created at: ${REGISTRATION_FILE}"
        log_info "Add this to your Matrix homeserver configuration"
        exit 0
    fi
}

cleanup() {
    if [[ -n "${BRIDGE_PID:-}" ]]; then
        log_info "Shutting down bridge process"
        kill -TERM "${BRIDGE_PID}" 2>/dev/null || true
        wait "${BRIDGE_PID}" 2>/dev/null || true
    fi
}

trap cleanup SIGTERM SIGINT SIGQUIT

main() {
    log_info "Starting mautrix-meta bridge"

    if [[ $EUID -eq 0 ]]; then
        log_error "Running as root is not allowed"
        exit 1
    fi

    if [[ ! -w "/data" ]]; then
        log_error "Data directory /data is not writable"
        exit 1
    fi

    init_config

    if ! validate_config; then
        log_error "Configuration validation failed"
        exit 1
    fi

    check_permissions "${CONFIG_FILE}"
    check_permissions "${REGISTRATION_FILE}"

    init_registration

    log_info "Starting bridge process"
    /usr/bin/mautrix-meta -c "${CONFIG_FILE}" --no-update &
    BRIDGE_PID=$!

    wait "${BRIDGE_PID}"
    EXIT_CODE=$?

    if [[ ${EXIT_CODE} -ne 0 ]]; then
        log_error "Bridge exited with code: ${EXIT_CODE}"
    fi

    exit "${EXIT_CODE}"
}

main "$@"
