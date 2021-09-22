#!/usr/bin/env bash
is_mac() {
    [[ -d /Applications/Safari.app && -d /Users ]]
}

xcode_tools_installed() {
    [[ -d /Library/Developer/CommandLineTools ]]
}

homebrew_installed() {
    [[ -f /usr/local/bin/brew ]]
}

elasticsearch_installed() {
    [[ -d /usr/local/var/homebrew/linked/elasticsearch-full ]]
}

install_homebrew() {
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    echo "Adding homebrew services control..."
    HOMEBREW_NO_AUTO_UPDATE=1 brew tap homebrew/services
}

add_the_elasticsearch_repo() {
    echo "Adding the elasticsearch repository..."
    HOMEBREW_NO_AUTO_UPDATE=1 brew tap elastic/tap
}

install_elasticsearch() {
    echo "Installing elasticsearch..."
    HOMEBREW_NO_AUTO_UPDATE=1 brew install elastic/tap/elasticsearch-full
}

enable_elasticsearch_as_a_service() {
    echo "Starting elasticsearch as a service..."
    brew services start elastic/tap/elasticsearch-full
}

stop_elasticsearch() {
    echo "Stopping elasticsearch..."
    brew services stop elastic/tap/elasticsearch-full
}

uninstall_elasticsearch() {
    echo "Uninstalling elasticsearch..."
    brew uninstall elasticsearch-full
    echo "Removing elasticsearch homebrew folder..."
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
}

remove_the_elasticsearch_repo() {
    echo "Removing the elasticsearch repository..."
    HOMEBREW_NO_AUTO_UPDATE=1 brew untap elastic/tap
}