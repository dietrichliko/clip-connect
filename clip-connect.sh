#!/bin/bash -x
# /opt/clip-connect/clip-connect.sh
#
# openconnect wrapper
#
# Dietrich Liko

set -e

# openconnect prefers SIGINT

_term() {
  kill -INT "$pid" 2>/dev/null
}
trap _term SIGTERM

output=$(security find-generic-password -s clip-connect "${HOME}/Library/Keychains/login.keychain-db")
USERNAME=$(echo "$output" | awk '/"acct"/ { print substr($1,15,length($1)-15)}')
PASSWORD=$(security find-generic-password -s clip-connect -w "${HOME}/Library/Keychains/login.keychain-db")

OPENCONNECT='/opt/local/sbin/openconnect'

VPN_SLICE='vpn-slice 172.16.0.0/16 cbe.vbc.ac.at jupyterhub.vbc.ac.at docs.vbc.ac.at'
. /opt/clip-connect/venv/bin/activate
export LC_ALL="en_US.UTF-8"

VPN_URL="https://vpn.vbc.ac.at/AllSecure"

echo $PASSWORD | sudo $OPENCONNECT -u $USERNAME  --passwd-on-stdin $VPN_URL -s "$VPN_SLICE" &
rc=$?
pid=$!

if [ $rc -eq 0 ]
then
   wait "$pid"
else
   echo "openconnect return code $rc" 1>&2
fi
