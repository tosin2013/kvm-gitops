Advanced GitOps Deplopyments
==========================================
This is used if you would like to manage mutiple machines with different configurations. The configurations would be defined in the ``inventories/yourmachine/host_vars`` directory.


Change the ``example_script.sh`` items and run the script to configure fetchit to run on machine.

Options
-------
1. Change the GITURL
2. Change the username and password for git

Example Run::
    
    sudo su - root 
    curl -OL https://raw.githubusercontent.com/tosin2013/openshift-virtualization-gitops/main/scripts/example_script.sh
    chmod +x example_script.sh
    ./example_script.sh your_directory_name