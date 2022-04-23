#!/bin/bash
source functions.sh

if is_mac; then
    echo "PROGRESS:25"
    sleep 1
    stash_user_changes
    echo "PROGRESS:50"
    sleep 1
    update_app
    echo "PROGRESS:75"
    sleep 1
    reapply_user_changes
    echo "PROGRESS:100"
    echo "ALERT:Success|Application has been updated"
    echo "QUITAPP"
fi