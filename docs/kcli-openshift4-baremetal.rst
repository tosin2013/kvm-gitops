=====================================
Bare Metal IPI deployments using kcli 
=====================================

This repository provides a plan which deploys a vm where:

* openshift-baremetal-install is downloaded or compiled from source (with an additional list of PR numbers to apply)
* stop the nodes to deploy through redfish or ipmi
* launch the install against a set of baremetal nodes. Virtual masters and workers can also be deployed.
  
The automation can be used for additional scenarios:
* only deploying the virtual infrastructure needed for a baremetal ipi deployment
* deploying a spoke cluster (either multinodes or SNO) through ZTP on top of the deployed Openshift
  
`kcli-openshift4-baremetal <https://github.com/karmab/kcli-openshift4-baremetal>`_ 

Tested on Centos 8 streams

Configure Centos 8
-------------------
Instructions::

    sudo dnf install wget git vim unzip bind-utils ipcalc  -y
    sudo dnf upgrade -y

Configure Repo
--------------
To use locally follow the link below 
* `OpenShift Virtualization GitOps Repository <https://openshift-virtualization-gitops-repository.readthedocs.io/en/latest/#openshift-virtualization-gitops-repository>`_

To use external Git repo use the following steps::
    
    curl -OL https://raw.githubusercontent.com/tosin2013/openshift-virtualization-gitops/main/scripts/install.sh
    chmod +x install.sh
    export CONFIGURE_GITEA=false
    ./install.sh
    sudo su - admin 
    git clone https://github.com/tosin2013/qubinode-installer.git
    exit

Configure GitOps for Qubinode Installer
---------------------------------------
Configure GitOps::
    
    sudo su - root
    systemctl enable podman.socket --now
    mkdir -p /opt/fetchit
    mkdir -p ~/.fetchit
    GITURL="http://yourrepo:3000/tosin/openshift-virtualization-gitops.git"
    # Change Git URL to your Git Repo
    cat  >/root/.fetchit/config.yaml<<EOF
    targetConfigs:
    - url: ${GITURL}
      username: svc-gitea
      password: password
      filetransfer:
      - name: copy-vars
        targetPath: inventories/virtual-lab/host_vars
        destinationDirectory: /home/admin/qubinode-installer/playbooks/vars
        schedule: "*/1 * * * *"
      branch: main
    EOF

    cp /home/admin/openshift-virtualization-gitops/scripts/fetchit/fetchit-root.service /etc/systemd/system/fetchit.service
    systemctl enable fetchit --now

    podman ps 

    exit

Configure KVM using Qubinode::

    sudo su - admin 
    cd qubinode-installer
    ./qubinode-installer -m setup
    ./qubinode-installer -m rhsm
    ./qubinode-installer -m ansible
    ./qubinode-installer -m host
    ./qubinode-installer -p kcli
    ./qubinode-installer -p gozones


Links:
~~~~~~
`Documentation <https://ocp-baremetal-ipi-lab.readthedocs.io/en/latest/>