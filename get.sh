#!/bin/bash 
#
# Install clip-connect
#
# Dietrich Liko

echo "Install Split VON for CLIP" 1>&2

die() {
    echo "$@" 1>&2
    exit 1
}

# check python version
python -c 'import sys; exit(1) if sys.version_info.major < 3 and sys.version_info.minor < 3 else exit(0)' || die "clip-connect requires python 3.3+"

# find openconnect binary
for path in "/opt/local/sbin/openconnect" "/usr/local/bin/openconnect"
do
    [ -e $path ] && OPENCONNECT="$path"
done

[ -z "$OPENCONNECT" ] && die "No opneconnect binary found." 

TMPDIR="/tmp/clip-connect.$$"
mkdir "$TMPDIR"

curl -sL https://github.com/dietrichliko/clip-connect/tarball/main | tar xz --strip-components 1 -C "$TMPDIR"

CLIP_CONNECT_DIR="/opt/clip-connect"
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

sudo cat - <<EOF > /etc/sudoers.d/openconnect
%admin  ALL=(ALL) NOPASSWD: $OPENCONNECT
EOF

sudo cp "$TMPDIR/clip-connect.plist" ~/Library/LaunchAgents/clip-connect.plist

rm -rf $TMPDIR
launchctl load ~/Library/LaunchAgents/clip-connect.plist
