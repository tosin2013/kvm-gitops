ZTP Factory Workloads
==========================================

clone gitops-catalog from your repo::

    git clone  http://your-git-server:3000/svc-gitea/gitops-catalog.git 


Install Openshift Pipelines::

    oc login -u kubeadmin -p 4Z3-5Z3-5Z3-5Z3-5Z3 https://api.crc.testing:6443
    cd gitops-catalog/
    oc apply -k openshift-pipelines-operator/overlays/pipelines-1.7/

Install Openshift Local Storage Operator::

    oc login -u kubeadmin -p 4Z3-5Z3-5Z3-5Z3-5Z3 https://api.crc.testing:6443
    cd gitops-catalog/
    oc apply -k openshift-local-storage/operator/overlays/stable-4.11


Install Openshift Local Storage Instance::

    oc login -u kubeadmin -p 4Z3-5Z3-5Z3-5Z3-5Z3 https://api.crc.testing:6443
    cd gitops-catalog/
    # update kustomize with your node name
    vim openshift-local-storage/instance/overlays/bare-metal/kustomization.yaml
    oc apply -k openshift-local-storage/instance/overlays/bare-metal
    # push updates to git repo 

Install Openshift Data Foundation Operator::

    oc login -u kubeadmin -p 4Z3-5Z3-5Z3-5Z3-5Z3 https://api.crc.testing:6443
    cd gitops-catalog/
    oc apply -k openshift-data-foundation-operator/operator/overlays/stable-4.11

Install Openshift Data Foundation Instance::

    oc login -u kubeadmin -p 4Z3-5Z3-5Z3-5Z3-5Z3 https://api.crc.testing:6443
    cd gitops-catalog/
    oc apply -k openshift-data-foundation-operator/instance/overlays/bare-metal/