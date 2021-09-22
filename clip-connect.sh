#!/bin/bash -x
# /opt/clip-connect/clip-connect.sh
#
# openconnect wrapper
#
# Dietrich Liko, September 2021

set -e

_die() {
   echo "$@" 1>&2
   exit 1
}

# openconnect prefers SIGINT
_term() {
  kill -INT "$pid" 2>/dev/null
}
trap _term SIGTERM

USERNAME=$(security find-generic-password -s clip-connect "${HOME}/Library/Keychains/login.keychain-db" | awk '/"acct"/ { print substr($1,15,length($1)-15)}' )
PASSWORD=$(security find-generic-password -s clip-connect -w "${HOME}/Library/Keychains/login.keychain-db")

for path in "/opt/local/sbin/openconnect" "/usr/local/bin/openconnect"
do
    [ -e $path ] && OPENCONNECT="$path"
done
[ -z $OPENCONNECT ] &&  _die "No openconnect binary found"

VPN_URL="https://vpn.vbc.ac.at/AllSecure"
VPN_SLICE="vpn-slice 172.16.0.0/16 cbe.vbc.ac.at clip-login-0.cbe.vbc.ac.at clip-login-1.cbe.vbc.ac.at jupyterhub.vbc.ac.at docs.vbc.ac.at"

# shellcheck disable=SC1091
source /opt/clip-connect/venv/bin/activate

export LC_ALL="en_US.UTF-8"
echo "$PASSWORD" | sudo "$OPENCONNECT" -u "$USERNAME"  --passwd-on-stdin "$VPN_URL" -s "$VPN_SLICE" &
rc=$?
pid=$!

if [ $rc -eq 0 ]
then
   wait $pid
else
   echo "openconnect return code $rc" 1>&2
fi
