#!/bin/bash
source functions.sh

if is_mac; then
    echo "PROGRESS:0"
    
    if elasticsearch_installed; then
        stop_elasticsearch
        uninstall_elasticsearch
        echo "ALERT:Success|Elasticsearch has been successfully uninstalled"
        echo "QUITAPP"
    fi
    
    if [ ! xcode_tools_installed ]; then
        echo "ALERT:Warning|XCode Tools are not installed"
        echo "QUITAPP"
    fi
    
    if [ ! homebrew_installed ]; then
        echo "Homebrew is not installed";
        echo "ALERT:Warning|Homebrew is not installed"
        echo "QUITAPP"
    fi
    
    echo "PROGRESS:25"
    sleep 1
    install_elasticsearch
    echo "PROGRESS:50"
    sleep 1
    start_elasticsearch
    echo "PROGRESS:75"
    sleep 1
    echo "PROGRESS:100"
    echo "ALERT:Success|Elasticsearch has been successfully installed"
    echo "QUITAPP"
fi