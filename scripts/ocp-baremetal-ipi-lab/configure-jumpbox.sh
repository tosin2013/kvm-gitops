#!/bin/bash 
# kcli ssh  baremetal-installer
# sudo su - root

if [ -z "$1" ]; then
    echo "Usage: $0 ipmi|redfish"
    exit 1
fi
BOOT_TYPE=$1
dnf clean all
dnf install git unzip wget bind-utils python3-pip tar util-linux-user -y 

dnf install ncurses-devel curl -y
curl 'https://vim-bootstrap.com/generate.vim' --data 'editor=vim&langs=javascript&langs=go&langs=html&langs=ruby&langs=python' > ~/.vimrc

echo "configring powerline"
git clone https://github.com/jotyGill/ezsh
cd ezsh
./install.sh -c 

if [  $BOOT_TYPE == "redfish" ]; then
    bash /root/scripts/00_virtual.sh.redfish
    REDFISH_ADDRESS=$(grep -m 1 redfish-virtualmedia /root/install-config.yaml | sed 's/        address: redfish-virtualmedia+//')
    echo $REDFISH_ADDRESS || exit $?
    curl $REDFISH_ADDRESS
    redfish.py status
elif [ $BOOT_TYPE == "ipmi" ]; then
    bash /root/scripts/00_virtual.sh
else 
    echo "Unknown boot type"
    exit 1
fi

read -n 1 -s -r -p "Press any key to continue"

/root/scripts/01_patch_installconfig.sh
/root/scripts/02_packages.sh
/root/scripts/04_get_clients.sh
/root/scripts/05_cache.sh
#/root/scripts/06_disconnected_quay.sh
#/root/scripts/06_disconnected_mirror.sh
#/root/scripts/06_disconnected_olm.sh
/root/scripts/09_deploy_openshift.sh
