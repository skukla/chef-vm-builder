#!/usr/bin/env bash
source ../lib/functions.sh

if is_mac && xcode_tools_installed && homebrew_installed; then
    if elasticsearch_installed; then
        stop_elasticsearch
        uninstall_elasticsearch
        remove_the_elasticsearch_repo
    else
        add_the_elasticsearch_repo
        install_elasticsearch
        enable_elasticsearch_as_a_service
    fi
fi
