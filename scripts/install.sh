#!/bin/bash

set -xe 

sudo subscription-manager register
sudo subscription-manager refresh
sudo subscription-manager attach --auto
sudo subscription-manager repos --enable=rhel-8-for-x86_64-appstream-rpms --enable=rhel-8-for-x86_64-baseos-rpms
sudo dnf install git vim unzip wget bind-utils tar podman ansible jq python3-pip genisoimage nmstate dialog -y 


sudo curl -OL https://raw.githubusercontent.com/tosin2013/openshift-4-deployment-notes/master/pre-steps/configure-openshift-packages.sh
sudo chmod +x configure-openshift-packages.sh
sudo ./configure-openshift-packages.sh -i
rm configure-openshift-packages.sh

sudo pip3 install jmespath
sudo pip3 install j2cli
sudo pip3 install -U pywebio

sudo systemctl enable podman.socket
sudo systemctl start podman.socket
sudo systemctl status podman.socket

git clone https://github.com/tosin2013/openshift-4-deployment-notes.git
git clone https://github.com/tosin2013/openshift-virtualization-gitops.git
cd openshift-virtualization-gitops
sudo ansible-galaxy install --force -r roles/requirements.yml || exit $?
sudo ansible-galaxy collection install --force -r collections/requirements.yml|| exit $?

if [ ${CONFIGURE_GITEA} == true ]; then
    sudo useradd svc-gitea
    export GITEA_PASSWORD=$(openssl rand -base64 12) 
    export GITEA_URL=$(hostname -I | awk '{print $1}')
    echo "GITEA URL: http://${GITEA_URL}:3000" |  tee ${HOME}/gitea-password.txt
    echo "USERNAME: svc-gitea"| tee -a ${HOME}/gitea-password.txt
    echo "PASSWORD: ${GITEA_PASSWORD}"| tee -a ${HOME}/gitea-password.txt
    cat ${HOME}/gitea-password.txt
    sudo ansible-playbook -i  inventories/production/hosts configure-gitea.yml --extra-vars "gitea_admin=svc-gitea gitea_password=${GITEA_PASSWORD} endpoint=${GITEA_URL}"
    echo "cat ${HOME}/gitea-password.txt"
    sudo  firewall-cmd --permanent --zone=public --add-port=3000/tcp
fi

sudo  firewall-cmd --permanent --zone=public --add-port=8081/tcp
sudo firewall-cmd --reload