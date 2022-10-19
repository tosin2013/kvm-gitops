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

# Troubleshooting
* If you are having issues logging on to gitea from the user stop and start the podman container.


Links
------
* [GitOps](https://github.com/cablelabs/gitops)
* [fetchit](https://github.com/containers/fetchit)
