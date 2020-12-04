#/bin/bash
# set-up-certificates.sh

for FILE in ./certificate/*; do
    COMMON_NAME="${FILE##*/}"
    COMMON_NAME="${COMMON_NAME%.*}"
    sudo security find-certificate -c $COMMON_NAME > /dev/null 2>&1
    RESULT=$?
    if [ $RESULT -eq 0 ]; then
        sudo security delete-certificate -c $COMMON_NAME /Library/Keychains/System.keychain
    fi
    printf "Adding certificate ${COMMON_NAME}"
    sudo security add-trusted-cert -d -r trustAsRoot -k /Library/Keychains/System.keychain ${FILE}
done