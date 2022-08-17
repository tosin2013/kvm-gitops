#!/bin/bash

set -xe 
CHECKLOGGINGUSER=$(whoami)
if [ ${CHECKLOGGINGUSER} == "root" ];
then 
  SUDO_USER=sudo
fi


${SUDO_USER} subscription-manager register
${SUDO_USER}  subscription-manager refresh
${SUDO_USER}  subscription-manager attach --auto
${SUDO_USER}  subscription-manager repos --enable=rhel-8-for-x86_64-appstream-rpms --enable=rhel-8-for-x86_64-baseos-rpms
${SUDO_USER}  dnf install git vim unzip wget bind-utils tar podman ansible -y 


curl -OL https://raw.githubusercontent.com/tosin2013/openshift-4-deployment-notes/master/pre-steps/configure-openshift-packages.sh
chmod +x configure-openshift-packages.sh
./configure-openshift-packages.sh -i
rm configure-openshift-packages.sh

git clone https://github.com/tosin2013/openshift-virtualization-gitops.git
cd openshift-virtualization-gitops
ansible-galaxy install --force -r roles/requirements.yml
ansible-galaxy collection install --force -r collections/requirements.yml