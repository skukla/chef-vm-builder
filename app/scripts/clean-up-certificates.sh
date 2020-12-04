#/bin/bash
# clean-up-certificates.sh
for FILE in './certificate/*'; do 
    sudo security find-certificate -c $FILE > /dev/null 2>&1
    RESULT=$?
    if [ $RESULT -eq 0 ]; then
        echo "Removing $FILE"
        sudo security delete-certificate -c $FILE /Library/Keychains/System.keychain
    fi
done