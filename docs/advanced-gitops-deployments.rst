Advanced GitOps Deplopyments
==========================================
This is used if you would like to manage mutiple machines with different configurations. The configurations would be defined in the ``inventories/yourmachine/host_vars`` directory.


Change the ``example_script.sh`` items and run the script to configure fetchit to run on machine.

Options
~~~~~~~
* **TESTED:** `qubinode-installer <https://github.com/tosin2013/qubinode-installer>`_ - Qubinode-installer is an utility tool that facilates the quick deployment of an array of Red Hat products like Red Hat Openshift Container Platform, Red Hat Identity Manager, Red Hat Satellite, etc.. on a single piece of hardware by leveraging the KVM hypervisor.  
* **TESTING:**  `kcli-openshift4-baremetal <https://github.com/karmab/kcli-openshift4-baremetal>`_ - deploy baremetal ipi using a dedicated vm
* **TESTING:** `kcli-openshift4-baremetal-lab` - deploy baremetal ipi using a dedicated vm emulated with qubinode installer
* **TESTED:** `openshift-4-deployment-notes <https://github.com/tosin2013/openshift-4-deployment-notes/tree/master/assisted-installer>`_ - Assisted Installer Steps for Bare Metal machines with Static IPs
* **TESTING:** `openshift-4-deployment-notes-lab`
* **Have not tested:** `openshift-aio <https://github.com/RHFieldProductManagement/openshift-aio>`_ - Welcome to our OpenShift All-in-One deployment automation repository. Here you'll find Ansible playbooks that will allow you to deploy an "all in one" configuration of OpenShift with a wide variety of options and extensions via operators.

Example Run::
    
    sudo su - root 
    curl -OL https://raw.githubusercontent.com/tosin2013/openshift-virtualization-gitops/main/scripts/example_script.sh
    chmod +x example_script.sh
    ./example_script.sh yqubinode-installer example http://gitea.example.com:3000/tosin/openshift-virtualization-gitops.git gituser password

Adter Anisble Playbook ```configure-host.yml``` run::

    sudo su - root
    bash example_script.sh qubinode-installer example http://gitea.example.com:3000/tosin/openshift-virtualization-gitops.git gituser password


