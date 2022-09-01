#!/bin/bash

set -xe 

subscription-manager register
subscription-manager refresh
subscription-manager attach --auto
subscription-manager repos --enable=rhel-8-for-x86_64-appstream-rpms --enable=rhel-8-for-x86_64-baseos-rpms
dnf install git vim unzip wget bind-utils tar podman ansible jq python3-pip genisoimage nmstate dialog -y 


curl -OL https://raw.githubusercontent.com/tosin2013/openshift-4-deployment-notes/master/pre-steps/configure-openshift-packages.sh
chmod +x configure-openshift-packages.sh
./configure-openshift-packages.sh -i
rm configure-openshift-packages.sh

pip3 install jmespath
pip3 install j2cli
pip3 install -U pywebio

git clone https://github.com/tosin2013/openshift-4-deployment-notes.git
git clone https://github.com/tosin2013/openshift-virtualization-gitops.git
cd openshift-virtualization-gitops
ansible-galaxy install --force -r roles/requirements.yml
ansible-galaxy collection install --force -r collections/requirements.yml

sudo useradd svc-gitea
export GITEA_PASSWORD=$(openssl rand -base64 12) 
export GITEA_URL=$(hostname -I | awk '{print $1}')
echo "GITEA URL: http://${GITEA_URL}:3000" |  tee ${HOME}/gitea-password.txt
echo "USERNAME: svc-gitea"| tee -a ${HOME}/gitea-password.txt
echo "PASSWORD: ${GITEA_PASSWORD}"| tee -a ${HOME}/gitea-password.txt
cat ${HOME}/gitea-password.txt
ansible-playbook -i  inventories/production/hosts configure-gitea.yml --extra-vars "gitea_admin=svc-gitea gitea_password=${GITEA_PASSWORD} endpoint=${GITEA_URL}"
echo "cat ${HOME}/gitea-password.txt"

sudo  firewall-cmd --permanent --zone=public --add-port=8081/tcp
sudo firewall-cmd --reload