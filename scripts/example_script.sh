#!/bin/bash

if [ -z "$1" ]; then
    echo "No argument supplied"
    exit 1
fi


GITURL="http://yourrepo:3000/tosin/openshift-virtualization-gitops.git"
if [ ! -d $HOME/openshift-virtualization-gitops ];
then
    git clone $GITURL
fi

if [ ! -d $HOME/openshift-virtualization-gitops/inventories/${1} ];
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
    targetPath: inventories/${1}/host_vars
    destinationDirectory: /home/admin/qubinode-installer/playbooks/vars
    schedule: "*/1 * * * *"
  branch: main
EOF

cp /home/admin/openshift-virtualization-gitops/scripts/fetchit/fetchit-root.service /etc/systemd/system/fetchit.service
systemctl enable fetchit --now
