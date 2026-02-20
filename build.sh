#!/usr/bin/env bash

export MATTERMOST_VERSION=$(cat mattermost_version)

download_mattermost() {
    local tarball="mattermost-team-${MATTERMOST_VERSION}-linux-amd64.tar.gz"
    local cache_file="${PLATFORM_CACHE_DIR}/${tarball}"

    if [ -f "$cache_file" ]; then
        printf "\n  ✔ \033[1mUsing cached Mattermost archive\033[0m ($MATTERMOST_VERSION)\n\n"
    else
        printf "\n  ✔ \033[1mDownloading Mattermost...\033[0m ($MATTERMOST_VERSION)\n\n"
        wget --quiet -c "https://releases.mattermost.com/${MATTERMOST_VERSION}/${tarball}" -O "$cache_file"
    fi

    tar -xzf "$cache_file"
    cp -a mattermost/* .
    chmod +x bin/mattermost
}

set_config() {
    cp config/config.json config.default
}

set -e
download_mattermost
set_config
