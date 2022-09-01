OpenShift Virtualization GitOps Repository
------------------------------------------
This repository is used to manage the OpenShift Virtualization GitOps Deployments in a Gitops Manner. 

Requirements
------------
* RHEL 8.x tested on RHEL 8.6

Quick start
------------
```
curl -OL https://raw.githubusercontent.com/tosin2013/openshift-virtualization-gitops/main/scripts/install.sh
chmod +x install.sh
./install.sh
```

## Using UI
python3 scripts/setup.py
go to http://localhost:8081/ or http://ipaddress:8081/ui/


## Manual Installation

## 1. Deploy OpenShift Cluster 
```
cd openshift-4-deployment-notes/assisted-installer/

CLUSTER_SIZE=sno  # sno, converged, full
cp $HOME/openshift-virtualization-gitops/example/${CLUSTER_SIZE}-cluster-vars.sh cluster-vars.sh
```

1. Get offline token and save it to `~/rh-api-offline-token`
> [Red Hat API Tokens](https://access.redhat.com/management/api)

```bash
vim ~/rh-api-offline-token
```

2. Get OpenShift Pull Secret and save it to `~/ocp-pull-secret`
> [Install OpenShift on Bare Metal](https://console.redhat.com/openshift/install/metal/installer-provisioned)

```bash
vim ~/ocp-pull-secret
```
3. Run the bootstrap script to create the cluster, configure it, and download the ISO
> the bootstrap-create.sh script may also be used. 
```bash
./bootstrap.sh
./hack/create-kvm-vms.sh # Change the CPU and Memory to match your requirements then run this script
./bootstrap-install.sh # you may have to login to console.redhat.com and hit install 

./hack/watch-and-reboot-kvm-vms.sh

./bootstrap-post-install.sh
```
## 2. Configure ODF 

### Option 1: Internal OpenShit ODF instance

### Option 2: External OpenShit ODF instance (Using Ceph Cluster)


## 3. Configure Openshift Virtualization

## 4. Configure GitOps Via ACM

Links
------
* [GitOps](https://github.com/cablelabs/gitops)
* [fetchit](https://github.com/containers/fetchit)
