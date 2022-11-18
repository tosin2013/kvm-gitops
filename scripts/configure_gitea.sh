#!/bin/bash 
#git clone https://github.com/tosin2013/openshift-4-deployment-notes.git
git clone https://github.com/tosin2013/kvm-gitops.git
cd kvm-gitops
sudo ansible-galaxy install --force -r roles/requirements.yml || exit $?
sudo ansible-galaxy collection install --force -r collections/requirements.yml|| exit $?

if [ ${CONFIGURE_GITEA} == true ]; then
    sudo useradd svc-gitea
    #export GITEA_PASSWORD=$(openssl rand -base64 12) 
    export GITEA_PASSWORD='git3ap@33w0rd'
    export GITEA_URL=$(hostname -I | awk '{print $1}')
    echo "GITEA URL: http://${GITEA_URL}:3000" |  tee ${HOME}/gitea-password.txt
    echo "USERNAME: svc-gitea"| tee -a ${HOME}/gitea-password.txt
    echo "PASSWORD: ${GITEA_PASSWORD}"| tee -a ${HOME}/gitea-password.txt
    cat ${HOME}/gitea-password.txt
    sudo ansible-playbook -i  inventories/production/hosts configure-gitea.yml --extra-vars "gitea_admin=svc-gitea gitea_password=${GITEA_PASSWORD} endpoint=${GITEA_URL}"
    echo "cat ${HOME}/gitea-password.txt"
    sudo  firewall-cmd --permanent --zone=public --add-port=3000/tcp
    sudo podman stop gitea
    sudo podman start gitea
    sudo podman generate systemd --new gitea > gitea.service 
    sudo cp gitea.service /etc/systemd/system
    sudo systemctl daemon-reload
fi
