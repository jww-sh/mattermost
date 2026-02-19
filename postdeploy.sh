#!/usr/bin/env bash

first_deploy() {
    printf "\n\033[1mInitializing Mattermost on first deploy...\033[0m\n"
    printf "\n  ✔ \033[1mCreating initial admin user\033[0m ($PSH_INITADMIN_USERNAME/$PSH_INITADMIN_EMAIL/$PSH_INITADMIN_PASSWORD)\n      "
    ./bin/mmctl user create --local --username $PSH_INITADMIN_USERNAME --email $PSH_INITADMIN_EMAIL --password $PSH_INITADMIN_PASSWORD
    printf "\n  ✔ \033[1mCreating initial private team\033[0m ($PSH_FIRSTTEAM_NAME/$PSH_FIRSTTEAM_DISPLAYNAME)\n    "
    ./bin/mmctl team create --local --name $PSH_FIRSTTEAM_NAME --display-name $PSH_FIRSTTEAM_DISPLAYNAME --private
    printf "\n  ✔ \033[1mCreating initial channel\033[0m ($PSH_FIRSTCHANNEL_NAME/$PSH_FIRSTCHANNEL_DISPLAYNAME)\n    "
    ./bin/mmctl channel create --local --team $PSH_FIRSTTEAM_NAME --name $PSH_FIRSTCHANNEL_NAME --display-name $PSH_FIRSTCHANNEL_DISPLAYNAME
    printf "\n  ✔ \033[1mPosting welcome/warning messages to channel...\033[0m\n    "
    ./bin/mmctl post create --local $PSH_FIRSTTEAM_NAME:$PSH_FIRSTCHANNEL_NAME --message "$PSH_WELCOME_MESSAGE"
    ./bin/mmctl post create --local $PSH_FIRSTTEAM_NAME:$PSH_FIRSTCHANNEL_NAME --message "$PSH_WARNING_MESSAGE1"
    ./bin/mmctl post create --local $PSH_FIRSTTEAM_NAME:$PSH_FIRSTCHANNEL_NAME --message "$PSH_WARNING_MESSAGE2"
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
