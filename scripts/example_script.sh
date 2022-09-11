#!/bin/bash
# example example_script.sh kcli-openshift4-baremetal-dsal "http://yourrepo:3000/tosin/openshift-virtualization-gitops.git svc-gitea CHANGEME"
if [ $# -ne 4 ]; then
    echo "Usage: $0 <directory_path> <git_url> <git_username> <git_password>"
    exit 1
fi


DIRECTORY_PATH=$1
GITURL=$2
GIT_USERNAME=$3
GIT_PASSWORD=$4

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
  username: ${GIT_USERNAME}
  password: ${GIT_PASSWORD}
  filetransfer:
  - name: copy-vars
    targetPath: inventories/${DIRECTORY_PATH}/host_vars
    destinationDirectory: /home/admin/qubinode-installer/playbooks/vars
    schedule: "*/1 * * * *"
  branch: main
EOF

cp $HOME/openshift-virtualization-gitops/scripts/fetchit/fetchit-root.service /etc/systemd/system/fetchit.service
systemctl enable fetchit --now
