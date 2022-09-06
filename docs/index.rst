OpenShift Virtualization GitOps Repository
==========================================

This repository is used to manage the OpenShift Virtualization GitOps Deployments in a Gitops Manner. 

Requirements
------------
* RHEL 8.x tested on RHEL 8.6

Quick start::

    curl -OL https://raw.githubusercontent.com/tosin2013/openshift-virtualization-gitops/main/scripts/install.sh
    chmod +x install.sh
    export CONFIGURE_GITEA=true
    ./install.sh
