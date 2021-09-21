#!/bin/bash
#
# Keychain: ~/Library/Keychains/login.keychain-db
# Service: clip-connect
#
# Dietrich Liko

keychain="${HOME}/Library/Keychains/login.keychain-db"

output=$(security find-generic-password -s clip-connect "$keychain")
if [ $? -eq 0 ]
then
   echo -n "Username: "
   echo "$output" | grep "acct" | cut -d \" -f 4 
   echo "Password: XXXXXXX"
   read -p "Do you want to set new credentials ? [N/y] " answer
   if [ "$answer" != "y" ]
   then
      exit
   fi
   security delete-generic-password -s clip-connect "$keychain" >/dev/null
else
   echo "No CLIP credentials found." 
fi

read -p "CLIP Username: " user
read -sp "CLIP Password: " password

security add-generic-password -s clip-connect -a "$user"  -w "$password" -j "Openconnect VPN" "$keychain"
