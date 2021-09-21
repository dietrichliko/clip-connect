#!/bin/bash
#
# Uninstall clip-connect
#
# Dietrich Liko

launchctl stop   ~/Library/LaunchAgents/clip-connect.plist
launchctl unload ~/Library/LaunchAgents/clip-connect.plist

sudo rm -rf /opt/clip-connect
sudo rm -f /etc/sudoers.d/openconnect
sudo rm -f ~/Library/LaunchAgents/clip-connect.plist
