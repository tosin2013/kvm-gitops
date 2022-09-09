#!/bin/bash 
# VLAN 20 offline dhcp
# VLAN 30 static network offlinne
# VLAN 10 dhcp 
# VLAN 50 online network
# VLAN 70 static network  offline 
# VLAN 60  network  offline



VLANID=20
BRIDGE=baremetal
IP="192.168.20.5/24"
sudo nmcli connection add ifname baremetal type bridge con-name baremetal
sudo nmcli connection add type vlan con-name eno2.20 ifname eno2.20 dev eno2 id 20 master $BRIDGE slave-type bridge
sudo nmcli connection modify $BRIDGE ipv4.addresses $IP ipv4.method manual
sudo nmcli con down $BRIDGE
sudo nmcli con up $BRIDGE
sudo nmcli con down $MAIN_CONN; sudo pkill dhclient; sudo dhclient baremetal


VLANID=30
BRIDGE=baremetal
IP="192.168.30.5/24"
sudo nmcli connection add ifname baremetal type bridge con-name baremetal
sudo nmcli connection add type vlan con-name eno2.30 ifname eno2.30 dev eno2 id 30 master $BRIDGE slave-type bridge
sudo nmcli connection modify $BRIDGE ipv4.addresses $IP ipv4.method manual
sudo nmcli con down $BRIDGE
sudo nmcli con up $BRIDGE
sudo nmcli con down $MAIN_CONN; sudo pkill dhclient; sudo dhclient baremetal


VLANID=10
BRIDGE=baremetal
IP="192.168.10.5/24"
sudo nmcli connection add ifname baremetal type bridge con-name baremetal
sudo nmcli connection add type vlan con-name eno2.10 ifname eno2.10 dev eno2 id 10 master $BRIDGE slave-type bridge
sudo nmcli connection modify $BRIDGE ipv4.addresses $IP ipv4.method manual
sudo nmcli con down $BRIDGE
sudo nmcli con up $BRIDGE
sudo nmcli con down $MAIN_CONN; sudo pkill dhclient; sudo dhclient baremetal

VLANID=70
BRIDGE=baremetal
IP="192.168.70.5/24"
sudo nmcli connection add ifname baremetal type bridge con-name baremetal
sudo nmcli connection add type vlan con-name eno2.70 ifname eno2.70 dev eno2 id 70 master $BRIDGE slave-type bridge
sudo nmcli connection modify $BRIDGE ipv4.addresses $IP ipv4.method manual
sudo nmcli con down $BRIDGE
sudo nmcli con up $BRIDGE
sudo nmcli con down $MAIN_CONN; sudo pkill dhclient; sudo dhclient baremetal