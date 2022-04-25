#!/usr/bin/env bash
is_mac() {
    [[ -d /Applications/Safari.app && -d /Users ]]
}

xcode_tools_installed() {
    xcode-select -p &> /dev/null
    [ $? -eq 0 ]
}

homebrew_installed() {
    which -s brew
    [ $? -eq 0 ]
}

elasticsearch_installed() {
    which -s elasticsearch
    [ $? -eq 0 ]
}

elasticsearch_is_running() {
    curl --stderr - localhost:9200 | grep -q cluster_name
    [ $? -eq 0 ]
}

install_homebrew() {
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    echo "Adding Homebrew services control..."
    HOMEBREW_NO_AUTO_UPDATE=1 brew tap homebrew/services
}

install_elasticsearch() {
    echo "Adding the Elasticsearch repository..."
    HOMEBREW_NO_AUTO_UPDATE=1 brew tap elastic/tap
    
    echo "Installing the Elasticsearch application..."
    HOMEBREW_NO_AUTO_UPDATE=1 brew install elastic/tap/elasticsearch-full
}

start_elasticsearch() {
    echo "Starting Elasticsearch as a service..."
    HOMEBREW_NO_AUTO_UPDATE=1 brew services start elastic/tap/elasticsearch-full
}

wait_for_elasticsearch_to_become_available() {
    host="localhost:9200"
    
    until $(curl --output /dev/null --silent --head --fail "$host"); do
        sleep 1
    done
    
    # First wait for ES to start...
    response=$(curl $host)
    
    until [ "$response" = "200" ]; do
        response=$(curl --write-out %{http_code} --silent --output /dev/null "$host")
        sleep 1
    done
    
    # next wait for ES status to turn to Green
    health="$(curl -fsSL "$host/_cat/health?h=status")"
    health="$(echo "$health" | sed -r 's/^[[:space:]]+|[[:space:]]+$//g')" # trim whitespace (otherwise we'll have "green ")
    
    until [ "$health" = 'green' ]; do
        health="$(curl -fsSL "$host/_cat/health?h=status")"
        health="$(echo "$health" | sed -r 's/^[[:space:]]+|[[:space:]]+$//g')" # trim whitespace (otherwise we'll have "green ")
        sleep 1
    done
    
    echo "Elasticsearch is available"
}

stop_elasticsearch() {
    echo "Stopping Elasticsearch..."
    HOMEBREW_NO_AUTO_UPDATE=1 brew services stop elastic/tap/elasticsearch-full
}

wipe_elasticsearch() {
    echo "Wiping Elasticsearch..."
    curl -XDELETE localhost:9200/_all
}

uninstall_elasticsearch() {
    echo "Uninstalling Elasticsearch..."
    HOMEBREW_NO_AUTO_UPDATE=1 brew uninstall elasticsearch-full
    
    echo "Removing the Elasticsearch Homebrew folder..."
    rm -rf /usr/local/var/homebrew/linked/elasticsearch-full
    
    echo "Removing configuration files..."
    rm -rf /usr/local/etc/elasticsearch/
    
    echo "Removing application data..."
    rm -rf /usr/local/var/lib/elasticsearch/
    
    echo "Removing logs..."
    rm -rf  /usr/local/var/log/elasticsearch/
    
    echo "Removing plugins..."
    rm -rf /usr/local/var/homebrew/linked/elasticsearch/plugins/
    rm -rf /usr/local/var/elasticsearch/
    
    echo "Removing the Elasticsearch repository..."
    HOMEBREW_NO_AUTO_UPDATE=1 brew untap elastic/tap
}

set_branch() {
    cd ../../../../../
    git checkout beta
}

stash_user_changes() {
    echo "Saving user changes..."
    git stash
}

update_app() {
    echo "Updating application..."
    git pull
}

reapply_user_changes() {
    echo "Re-applying user changes..."
    git stash apply
    git stash drop
}
