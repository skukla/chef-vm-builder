#!/bin/bash

# Set terminal color variables
export TERM=xterm-256color
BOLD=$(tput bold)
REG=$(tput sgr0)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)

# Define functions
rule () {
    printf -v _hr "%*s" $(tput cols) && echo ${_hr// /${1--}}
}

rulem ()  {
    printf -v _hr "%*s" $(tput cols) && echo -en ${_hr// /${2--}} && echo -e "\r\033[2C$1"
}

print_section_header() {
    rulem "[ ${CYAN}$1${REG} ]"
    printf '\n'
}

print_commands() {
    local commands=("$@")
    local i
    for ((i = 0; i < ${#commands[@]}; i+=2)); do
        printf '%-30s : %s\n' "${MAGENTA}${commands[i]}${REG}" "${REG}${commands[i+1]}"
    done
}

# Main

clear

figlet VM CLI

print_section_header "VM Command Reference"

print_commands "www" "Moves into the web root." \
              "clean" "Re-indexes and clears cache." \
              "cache" "Clears cache only." \
              "dev-mode" "Puts application into developer mode." \
              "prod-mode" "Puts application into production mode." \
              "cron" "Runs a single cron job" \
              "process-catalogs" "Processes B2B Shared Catalogs (Runs \"clean\" and a single cron trigger)." \
              "process-data" "Runs a cron job and watches the data installer log for data pack processing." \
              "resync-services" "Resynchronizes commerce services (Live Search, Product Recs, Catalog, etc)." \
              "backup-project" "Take a backup of your build. Exports backup to your local machine in the vm/backup directory."
printf "\n\n"

rule
printf "\n"
echo "Use ${MAGENTA}motd${REG} to go to the VM dashboard."
printf "\n"
