#!/bin/bash 
#
# Install clip-connect
#
# Dietrich Liko

echo "Install Split VPN for CLIP" 1>&2

_die() {
    echo "$@" 1>&2
    exit 1
}

# check python version
python -c 'import sys; exit(1) if sys.version_info.major < 3 and sys.version_info.minor < 3 else exit(0)' \
    || _die "clip-connect requires python 3.3+"

# find openconnect binary
for path in "/opt/local/sbin/openconnect" "/usr/local/bin/openconnect"
do
    [ -e $path ] && OPENCONNECT="$path"
done

[ -e "$OPENCONNECT" ] || _die "No openconnect binary found." 

CLIP_CONNECT_DIR="/opt/clip-connect"

[ -e $CLIP_CONNECT_DIR ] && _die "clip-connect already installed. Remove using $CLIP_CONNECT_DIR/uninstall.sh"

TMPDIR="/tmp/clip-connect.$$"
mkdir "$TMPDIR"

echo "Downloading http://github.com/dietrichliko/clip-connect" 1>&2
curl -sL https://github.com/dietrichliko/clip-connect/tarball/main | tar xz --strip-components 1 -C "$TMPDIR"


echo "Installing python libraries" 1>&2
sudo mkdir "$CLIP_CONNECT_DIR"
sudo python -m venv "$CLIP_CONNECT_DIR/venv"

# shellcheck disable=SC1091
. "$CLIP_CONNECT_DIR/venv/bin/activate"

sudo -H pip install --upgrade pip
sudo -H pip install vpn-slice

for name in "clip-connect.sh" "clip-credentials.sh" "uninstall.sh"
do
   sudo cp "$TMPDIR/$name" "$CLIP_CONNECT_DIR"
done

cat - <<EOF > "$TMPDIR/openconnect.sudo"
%admin  ALL=(ALL) NOPASSWD: $OPENCONNECT
EOF
sudo cp $TMPDIR/openconnect.sudo /etc/sudoers.d/openconnect
sudo cp "$TMPDIR/clip-connect.plist" ~/Library/LaunchAgents/clip-connect.plist

rm -rf $TMPDIR

$CLIP_CONNECT_DIR/clip-credentials.sh

launchctl load ~/Library/LaunchAgents/clip-connect.plist
