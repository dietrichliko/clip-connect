#!/bin/bash 
#
# Install clip-connect
#
# Dietrich Liko

sudo mkdir /opt/clip-connect
sudo python -m venv /opt/clip-connect/venv

. /opt/clip-connect/venv/bin/activate

sudo -H pip install --upgrade pip
sudo -H pip install vpn-slice


sudo cp openconnect.sudo /etc/sudoers.d/openconnect
sudo cp clip-connect.sh /opt/clip-connect/clip-connect.sh
sudo cp uninstall.sh /opt/clip-connect/uninstall.sh
sudo cp clip-connect.plist ~/Library/LaunchAgents/clip-connect.plist
launchctl load ~/Library/LaunchAgents/clip-connect.plist
