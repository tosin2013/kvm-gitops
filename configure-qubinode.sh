#!/bin/bash 

if [ -d /root/qubinode-installer ];
then
    echo "Directory exists"
else
    echo "/root/qubinode-installer does not exist"
    exit 1
fi

ln -s /root/openshift-virtualization-gitops/inventories/virtual-lab/host_vars/all.yml  /root/qubinode-installer/playbooks/vars/
