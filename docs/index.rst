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


Optional: Configure Git Repo
----------------------------
Access the Git Repo::
    
    $ cat ~/gitea-password.txt

.. image:: https://i.imgur.com/YyW1EwK.png
   :width: 600



Commit local OpenShift virtualization repo to the Git Repo::

    $ git remote remove origin
    $ git remote add origin http://yourip:3000/svc-gitea/openshift-virtualization-gitops.git
    $ git push --set-upstream origin main


Optional: Copy inventory to custom name example: r640
--------------------------------------------------------
Example:: 

    cp avi inventories/dev inventories/r640

**Make changes to repo and push to git repo**

Configure Fetchit
-----------------
To test the Fetchit, run the following command as root::

    sudo su - root
    ./scripts/configure-fetchit.sh

Advanced Deployment
~~~~~~~~~~~~~~~~~~~
Advanced Deployment Example::

    git clone https://github.com/tosin2013/qubinode-installer.git
    sudo su - root
    systemctl enable podman.socket --now
    mkdir -p /opt/fetchit
    mkdir -p ~/.fetchit

Change Git URL to your Git Repo::

    GITURL="http://yourrepo:3000/tosin/openshift-virtualization-gitops.git"
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

    cp /home/admin/openshift-virtualization-gitops/scripts/fetchit/fetchit-root.service /etc/systemd/system/fetchit.service
    systemctl enable fetchit --now

    podman ps 

    exit

Deploy OpenShift
----------------

Using UI::

    cd openshift-virtualization-gitops
    python3 scripts/setup.py
    go to http://localhost:8081/ or http://ipaddress:8081/ui/

.. image:: https://i.imgur.com/wfbeoFW.png
   :width: 600


Links
------
* `GitOps <https://github.com/cablelabs/gitops>`_
* `fetchit <https://github.com/containers/fetchit>`_