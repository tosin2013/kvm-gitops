#!/bin/bash
# example example_script.sh kcli-openshift4-baremetal-dsal "http://yourrepo:3000/tosin/openshift-virtualization-gitops.git"
if [ -z "$1" ]; then
    echo "No argument supplied"
    exit 1
fi

if [ $# -ne 2 ]; then
    echo "Usage: $0 <directory_path> <git_url>"
    exit 1
fi


DIRECTORY_PATH=$1
GITURL=$2

if [ ! -d $HOME/openshift-virtualization-gitops ];
then
    git clone $GITURL
fi

if [ ! -d $HOME/openshift-virtualization-gitops/inventories/${DIRECTORY_PATH} ];
then
    echo "${1} Directory does not exist please validate it exists and try again"
    exit 1
fi

systemctl enable podman.socket --now
mkdir -p /opt/fetchit
mkdir -p ~/.fetchit

# Change Git URL to your Git Repo
cat  >/root/.fetchit/config.yaml<<EOF
targetConfigs:
- url: ${GITURL}
  username: svc-gitea
  password: CHANGEME
  filetransfer:
  - name: copy-vars
    targetPath: inventories/${DIRECTORY_PATH}/host_vars
    destinationDirectory: /home/admin/qubinode-installer/playbooks/vars
    schedule: "*/1 * * * *"
  branch: main
EOF

cp $HOME/openshift-virtualization-gitops/scripts/fetchit/fetchit-root.service /etc/systemd/system/fetchit.service
systemctl enable fetchit --now
