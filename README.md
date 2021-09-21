# CLIP-CONNECT: Split VPN for CLIP on MacOSX

HEPHY users need only a subset of the IP range and the DNS names 
provided by the VPN server. Some subnets are also in conflict
with subnets at Apostelgasse and and in  many home environments.

The split VPN limits the IP range to 172.16.0.0/16  and DNS to relevant hosts

* cbe.vbc.ac.at 
* jupyterhub.vbc.ac.at 
* docs.vbc.ac.at

VPN is established on by (openconnect)[https://www.infradead.org/openconnect/] and 
VPN splitting is provided by (vpn-slice)[https://github.com/dlenski/vpn-slice].

The repository integrates the VPN into MacOSX environment using launchd.

## Installation



````bash
sudo port install python39
sudo port install openconnect
````

Python installation

````bash
curl -sL https://git.io/Jz8cM | bash
````

