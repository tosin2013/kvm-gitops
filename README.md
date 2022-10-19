KVM GitOps Repository
------------------------------------------
This repository is used to manage the KVM instances in a Gitops Manner. 

Tested On 
------------
* RHEL 8.x
* RHEL 9.x
* CentOS 9 Streams 
* Rocky Linux 8.x

Quick start
------------
**Using Shell Script**
```
curl -OL https://raw.githubusercontent.com/tosin2013/kvm-gitops/main/scripts/install.sh
chmod +x install.sh
./install.sh
```

**Using Ansible**
> This is useful when you want to use Ansible to install OpenShift Virtualization GitOps. Against remote machines.
```
sudo ansible-galaxy install --force -r roles/requirements.yml
sudo ansible-galaxy collection install --force -r collections/requirements.yml
ansible-playbook -i  inventories/production/hosts configure-host.yml --extra-vars "rhsm_activationkey=keyname rhsm_org_id=orgid"
```

# Optional: Install Gitea on Host
```
export CONFIGURE_GITEA=true
./scripts/configure_gitea.sh
```

## Optional: Configure Git Repo
Access the Git Repo
![20220901133951](https://i.imgur.com/YyW1EwK.png)
```
$ cat ~/gitea-password.txt
```

Commit local openshit virtualization repo to the Git Repo
```
$ git remote remove origin
$ git remote add origin http://yourip:3000/svc-gitea/kvm-gitops.git
$ git push --set-upstream origin main
```
## Optional: Copy inventory to custom name example: r640
```
cp avi inventories/dev inventories/r640
```
**Make changes to repo and push to git repo**

## Configure Fetchit
> To test the Fetchit, run the following command as root:
```
sudo su - root
./scripts/configure-fetchit.sh
```
**Optional: Advanced Deployment**
> See [Qubinode GitOps Deployment](https://qubinode-installer.readthedocs.io/en/latest/gitops_deployment.html) for more details.
```
sudo su - admin 
git clone https://github.com/tosin2013/qubinode-installer.git
sudo su - root
systemctl enable podman.socket --now
mkdir -p /opt/fetchit
mkdir -p ~/.fetchit

# Change Git URL to your Git Repo
GITURL="http://yourrepo:3000/tosin/kvm-gitops.git"
cat  >/root/.fetchit/config.yaml<<EOF
targetConfigs:
- url:  ${GITURL}
  username: svc-gitea
  password: password
  filetransfer:
  - name: copy-vars
    targetPath: inventories/virtual-lab/host_vars
    destinationDirectory: /home/admin/qubinode-installer/playbooks/vars
    schedule: "*/1 * * * *"
  branch: main
EOF

cp /home/admin/kvm-gitops/scripts/fetchit/fetchit-root.service /etc/systemd/system/fetchit.service
systemctl enable fetchit --now

podman ps 

exit
```

# Deploy OpenShift

## Using UI
![20220901131141](https://i.imgur.com/wfbeoFW.png)
```
cd kvm-gitops
python3 scripts/setup.py
go to http://localhost:8081/ or http://ipaddress:8081/ui/
```

## Manual Installation

## 1. Deploy OpenShift Cluster 
```
cd openshift-4-deployment-notes/assisted-installer/

CLUSTER_SIZE=sno  # sno, converged, full
cp $HOME/kvm-gitops/example/${CLUSTER_SIZE}-cluster-vars.sh cluster-vars.sh
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

# Troubleshooting
* If you are having issues logging on to gitea from the user stop and start the podman container.


Links
------
* [GitOps](https://github.com/cablelabs/gitops)
* [fetchit](https://github.com/containers/fetchit)
