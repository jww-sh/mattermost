#!/usr/bin/env bash

wait_for_socket() {
    local socket=".config/local/mattermost_local.socket"
    local max_wait=30
    local waited=0
    while [ $waited -lt $max_wait ]; do
        [ -S "$socket" ] && return 0
        sleep 1
        waited=$((waited + 1))
    done
    echo "Warning: Mattermost socket not ready after ${max_wait}s" >&2
}

first_deploy() {
    printf "\n\033[1mInitializing Mattermost on first deploy...\033[0m\n"
    wait_for_socket

    # Generate a random password: 20 alphanumeric chars + guaranteed symbol/digit/case chars
    local admin_password
    admin_password="$(openssl rand -base64 32 | tr -dc 'A-Za-z0-9' | head -c 20)!9Aa"

    printf "\n  ✔ \033[1mCreating initial admin user\033[0m ($PSH_INITADMIN_USERNAME/$PSH_INITADMIN_EMAIL)\n      "
    if ./bin/mmctl user create --local --username "$PSH_INITADMIN_USERNAME" --email "$PSH_INITADMIN_EMAIL" --password "$admin_password"; then
        printf "%s" "$admin_password" > .config/admin_credentials
    fi

    printf "\n  ✔ \033[1mCreating initial private team\033[0m ($PSH_FIRSTTEAM_NAME/$PSH_FIRSTTEAM_DISPLAYNAME)\n    "
    ./bin/mmctl team create --local --name $PSH_FIRSTTEAM_NAME --display-name $PSH_FIRSTTEAM_DISPLAYNAME --private
    ./bin/mmctl team users add --local $PSH_FIRSTTEAM_NAME $PSH_INITADMIN_USERNAME
    printf "\n  ✔ \033[1mCreating initial channel\033[0m ($PSH_FIRSTCHANNEL_NAME/$PSH_FIRSTCHANNEL_DISPLAYNAME)\n    "
    ./bin/mmctl channel create --local --team $PSH_FIRSTTEAM_NAME --name $PSH_FIRSTCHANNEL_NAME --display-name $PSH_FIRSTCHANNEL_DISPLAYNAME
    ./bin/mmctl channel users add --local $PSH_FIRSTTEAM_NAME:$PSH_FIRSTCHANNEL_NAME $PSH_INITADMIN_USERNAME
    printf "\n  ✔ \033[1mPosting welcome/warning messages to channel...\033[0m\n    "
    # mmctl post create is not available in local socket mode; use HTTP auth instead
    # --password-file is required; reuse the credentials file saved above
    ./bin/mmctl auth login "$MM_SERVICESETTINGS_SITEURL" --name deploy-session --username "$PSH_INITADMIN_USERNAME" --password-file .config/admin_credentials
    ./bin/mmctl post create $PSH_FIRSTTEAM_NAME:$PSH_FIRSTCHANNEL_NAME --message "$PSH_WELCOME_MESSAGE"
    ./bin/mmctl post create $PSH_FIRSTTEAM_NAME:$PSH_FIRSTCHANNEL_NAME --message "$PSH_WARNING_MESSAGE1"
    ./bin/mmctl post create $PSH_FIRSTTEAM_NAME:$PSH_FIRSTCHANNEL_NAME --message "$PSH_WARNING_MESSAGE2"
    ./bin/mmctl auth clean
    printf "\n\n\033[1m$PSH_WELCOME_MESSAGE\033[0m"
    printf "\n\033[1m$PSH_WARNING_MESSAGE1\033[0m"
    printf "\n\033[1m$PSH_WARNING_MESSAGE2\033[0m\n\n"
    # Keep track of first deploy.
    touch .config/upsun.installed
}

# Only run first_deploy on initial deployment
if [ ! -f .config/upsun.installed ]; then
    first_deploy
fi
