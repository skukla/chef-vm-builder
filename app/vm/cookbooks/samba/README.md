# samba

## Notes
1. As of the Catalina release, Apple has discontinued the support of the SMB 1 protocol in favor of SMB 2 and 3.  As such, the VM requires a minimum protocol of SMB 2, and supports a maximum protocol of SMB 3. 

2. If you're using Catalina and want to use more than two Samba shares, you'll need to disable packet signing. 

    See: [Turn off packet signing for SMB 2 and SMB 3 connections](https://support.apple.com/en-us/HT205926)