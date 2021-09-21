# VBC Connect

Establish a split VPN to CLIP on MacOSX

VPN is based on openconnect, VPN splitting is
provided by https://github.com/dlenski/vpn-slice


## Installation

Binary installations are dependiong on the tools 
you use.

In case you are useing  MacPorts

sudo port install python39
sudo port install openconnect


Python installation

git clone http://github.com/dietrichliko/vbc-connect

cd vbc-connect

python -m venv .venv
. ./.venv/bin/activate

pip install --upgrade pip wheel
pip install -r requirements.txt

