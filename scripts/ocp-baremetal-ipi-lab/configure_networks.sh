#!/bin/bash 

export MAIN_CONN=eno2
sudo nmcli connection add ifname baremetal type bridge con-name baremetal
sudo nmcli con add type bridge-slave ifname $MAIN_CONN master baremetal
sudo nmcli con down $MAIN_CONN; sudo pkill dhclient; sudo dhclient baremetal
