#!/usr/bin/env bash

set_config() {
    if [ ! -f config/config.json ] || [ ! -s config/config.json ]; then
        cp config.default config/config.json
    fi  
}

set_local(){
    # Always create the local directory for socket file (used by local mode)
    if [ ! -d ".config/local/" ]; then
        mkdir -p .config/local/
    fi

    if [ ! -f ".config/local/mattermost_local.socket" ]; then
        touch .config/local/mattermost_local.socket
    fi
}

set_config
set_local