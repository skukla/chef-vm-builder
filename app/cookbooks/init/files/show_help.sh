#!/bin/bash

# Variables
export TERM=xterm-256color
BOLD=$(tput bold)
REG=$(tput sgr0)
CYAN=$(tput setaf 6)

# Print a horizontal rule
rule () {
    printf -v _hr "%*s" $(tput cols) && echo ${_hr// /${1--}}
}

# Print horizontal ruler with message
rulem ()  {
    # Fill line with ruler character ($2, default "-"), reset cursor, move 2 cols right, print message
    printf -v _hr "%*s" $(tput cols) && echo -en ${_hr// /${2--}} && echo -e "\r\033[2C$1"
}

# Intro
clear
figlet VM Commands

# Useful Commands
rulem "[ ${CYAN}Command List${REG} ]"
printf '\n%23s : %s' "${BOLD}www" "${REG}Moves into the web root."
printf '\n%23s : %s' "${BOLD}clean" "${REG}Re-indexes and clears cache."
printf '\n%23s : %s' "${BOLD}cache" "${REG}Clears cache."
printf '\n%23s : %s' "${BOLD}reindex" "${REG}Reindexes all indexes."
printf '\n%23s : %s' "${BOLD}warm-cache" "${REG}Warms the Luma, Venia, and Custom store view caches."
printf '\n%23s : %s' "${BOLD}dev-mode" "${REG}Puts application into developer mode."
printf '\n%23s : %s' "${BOLD}prod-mode" "${REG}Puts application into production mode."
printf '\n%23s : %s' "${BOLD}process-catalogs" "${REG}Processes B2B Shared Catalogs (Runs \"clean\" and a single cron trigger)."
printf '\n%23s : %s' "${BOLD}disable-cms-cache" "${REG}Disables the block_html, layout, and full_page caches."
printf '\n%23s : %s' "${BOLD}enable-cache" "${REG}Enables all caches."
printf '\n%23s : %s' "${BOLD}cron" "${REG}Runs a single cron trigger."
printf '\n%23s : %s' "${BOLD}add-keys" "${REG}Adds SSH keys to the SSH agent."
printf '\n%23s : %s' "${BOLD}cloud-login" "${REG}Logs into the Cloud CLI in the VM.  May need to do this twice."
printf '\n%23s : %s' "${BOLD}configure-proxy" "${REG}Configures a proxy connection to download module updates."
printf '\n%23s : %s' "${BOLD}add-modules" "${REG}Triggers module updates which have been added to the composer.json file."
printf '\n%23s : %s' "${BOLD}upgrade" "${REG}Upgrade the codebase after adding a new module to your composer.json file."
printf '\n%23s : %s' "${BOLD}start-web" "${REG}Starts/Re-starts the web server."
printf '\n%23s : %s' "${BOLD}stop-web" "${REG}Stops the web server."
printf '\n%23s : %s' "${BOLD}status-web" "${REG}Shows web server status."
printf '\n%23s : %s' "${BOLD}db" "${REG}Logs into the Magento database as the Magento database user."
printf '\n%23s : %s' "${BOLD}start-db" "${REG}Starts/Re-starts MySQL."
printf '\n%23s : %s' "${BOLD}stop-db" "${REG}Stops MySQL."
printf '\n%23s : %s' "${BOLD}status-db" "${REG}Shows MySQL status."
printf '\n%23s : %s' "${BOLD}start-php" "${REG}Starts/Re-starts PHP-FPM."
printf '\n%23s : %s' "${BOLD}stop-php" "${REG}Stops PHP-FPM."
printf '\n%23s : %s' "${BOLD}status-php" "${REG}Shows PHP-FPM status."
printf '\n%23s : %s' "${BOLD}enable-elasticsearch" "${REG}Enables Elasticsearch to run as a service."
printf '\n%23s : %s' "${BOLD}start-elasticsearch" "${REG}Starts/Re-starts Elasticsearch."
printf '\n%23s : %s' "${BOLD}stop-elasticsearch" "${REG}Stops Elasticsearch."
printf '\n%23s : %s' "${BOLD}status-elasticsearch" "${REG}Shows Elasticsearch status."
printf '\n%23s : %s' "${BOLD}enable-samba" "${REG}Enables Samba to run as a service."
printf '\n%23s : %s' "${BOLD}start-samba" "${REG}Starts/Re-starts Samba."
printf '\n%23s : %s' "${BOLD}stop-samba" "${REG}Stops Samba."
printf '\n%23s : %s' "${BOLD}status-samba" "${REG}Shows Samba status."
printf '\n%23s : %s' "${BOLD}motd" "${REG}Shows the Message of the Day (BOOM message)."
printf '\n%23s : %s' "${BOLD}clear-cron-schedule" "${REG}Truncates Magento's cronfig.cron_schedule table"
printf '\n%23s : %s' "${BOLD}apply-patches" "${REG}Applies PMET patches if the ece-tools module is installed."
printf "\n\n"
rule