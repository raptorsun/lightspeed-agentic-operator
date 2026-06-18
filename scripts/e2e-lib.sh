#!/usr/bin/env bash
# Source this file; do not execute directly.

set -euo pipefail

log_info()  { echo "[INFO]  $(date -u '+%Y-%m-%dT%H:%M:%SZ') $*" >&2; }
log_warn()  { echo "[WARN]  $(date -u '+%Y-%m-%dT%H:%M:%SZ') $*" >&2; }
log_error() { echo "[ERROR] $(date -u '+%Y-%m-%dT%H:%M:%SZ') $*" >&2; }

check_prerequisites() {
    local missing=()
    for cmd in oc make go jq; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing required tools: ${missing[*]}"
        exit 1
    fi

    if ! oc whoami &>/dev/null; then
        log_error "Not logged in to an OpenShift cluster (oc whoami failed)"
        exit 1
    fi

    if ! oc whoami --show-server &>/dev/null; then
        log_error "Cluster not reachable (oc whoami --show-server failed)"
        exit 1
    fi

    log_info "Prerequisites OK: oc=$(oc version --client -o json | jq -r '.clientVersion.gitVersion // "unknown"'), cluster=$(oc whoami --show-server)"
}

parse_snapshot() {
    if [[ -n "${SNAPSHOT:-}" ]]; then
        local component_name="${KONFLUX_COMPONENT_NAME:?KONFLUX_COMPONENT_NAME must be set when SNAPSHOT is provided}"
        IMG="$(jq -r --arg component_name "$component_name" \
            '.components[] | select(.name == $component_name) | .containerImage' \
            <<< "$SNAPSHOT")"
        if [[ -z "$IMG" || "$IMG" == "null" ]]; then
            log_error "Could not extract operator image from SNAPSHOT for component '$component_name'"
            exit 1
        fi
        export IMG
        log_info "Extracted IMG=$IMG from SNAPSHOT (component=$component_name)"
    elif [[ -z "${IMG:-}" ]]; then
        log_error "Either SNAPSHOT or IMG must be set"
        exit 1
    else
        log_info "Using IMG=$IMG (no SNAPSHOT)"
    fi
}
