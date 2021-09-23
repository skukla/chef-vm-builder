#!/usr/bin/env bash
source ../lib/functions.sh

if is_mac && xcode_tools_installed && homebrew_installed; then
    if elasticsearch_installed; then
        stop_elasticsearch
        uninstall_elasticsearch
    else
        install_elasticsearch
        start_elasticsearch
    fi
fi
