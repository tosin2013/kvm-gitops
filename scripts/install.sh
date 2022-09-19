#!/bin/bash

set -xe 


function get_distro() {
    if [[ -f /etc/os-release ]]
    then
        # On Linux systems
        source /etc/os-release
        echo $ID
    else
        # On systems other than Linux (e.g. Mac or FreeBSD)
        uname
    fi
}

if [ $(get_distro) == "rhel" ]; then
    sudo subscription-manager register
    sudo subscription-manager refresh
    sudo subscription-manager attach --auto
    sudo subscription-manager repos --enable=rhel-8-for-x86_64-appstream-rpms --enable=rhel-8-for-x86_64-baseos-rpms
elif [ $(get_distro) == "centos" ]; then
    sudo yum install epel-release -y 
fi 

sudo dnf install git vim unzip wget bind-utils tar podman ansible-core jq python3-pip genisoimage nmstate dialog -y 

sudo curl -OL https://raw.githubusercontent.com/tosin2013/openshift-4-deployment-notes/master/pre-steps/configure-openshift-packages.sh
sudo chmod +x configure-openshift-packages.sh
sudo ./configure-openshift-packages.sh -i
sudo rm configure-openshift-packages.sh

sudo pip3 install jmespath
sudo pip3 install j2cli
sudo pip3 install -U pywebio

sudo systemctl enable podman.socket
sudo systemctl start podman.socket
sudo systemctl status podman.socket

sudo  firewall-cmd --permanent --zone=public --add-port=8081/tcp
sudo firewall-cmd --reload
