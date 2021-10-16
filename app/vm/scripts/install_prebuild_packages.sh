if [ $(dpkg-query -W -f='${Status}' jq 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    apt-get install -y jq > /dev/null 2>&1
fi