#!/usr/bin/env bash

set_config() {
    if [ ! -f config/config.json ] || [ ! -s config/config.json ]; then
        cp config.default config/config.json
    fi  
}

set_local(){
    # Always create the local directory for socket file (used by local mode)
    # Do not pre-create the socket file — Mattermost creates it as a proper Unix socket on startup
    mkdir -p .config/local/
    # Remove any stale non-socket file that would prevent Mattermost from binding
    if [ -e ".config/local/mattermost_local.socket" ] && [ ! -S ".config/local/mattermost_local.socket" ]; then
        rm -f .config/local/mattermost_local.socket
    fi
}

set_config
set_local