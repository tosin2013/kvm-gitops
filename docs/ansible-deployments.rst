Ansible Deployments
===================


git clone https://github.com/tosin2013/openshift-virtualization-gitops.git

cd openshift-virtualization-gitops
cp folder in inventory
```
cp inventories/name inventories/new-name
```

update name in hosts file 
```
vim  inventories/new-name/hosts
```

Copy ID to target server
```
ssh-copy-id admin@192.168.1.216
```


ansible-playbook -i inventories/virtual-lab/hosts  configure-host.yml --extra-vars "rhsm_activationkey=KEY rhsm_org_id=ORG_ID" -K