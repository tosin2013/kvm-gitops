#https://haydenjames.io/fix-error-failed-to-download-metadata-for-repo-appstream-centos-8/
sudo yum update -y
sudo yum epel-release -y
sudo dnf install wget git vim unzip bind-utils ansible -y
ansible-galaxy collection install containers.podman
sudo dnf upgrade -y

ansible-galaxy install -r playbooks/roles/requirements.yml -p playbooks/roles
ssh-copy-id root@$(hostname)