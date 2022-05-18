# Automate private RHACM with private AKS clusters

Goal of this document is document the various steps to configure the _Backup_ and the _Restore_  for *Private* RHACM Hub managing *private* AKS clusters. Here we supply _Ansible_ playbooks to automate the two processes

## Prerequirements

An Azure storage account with a container need to be configured and supplied tofor both backup and restore, no need to be created in the same reosurce group and subscription but then the RBAC has to be changed accordingly.

## Configure and run backup

Enter in `Python` virtual environment

```shell
$source venv/bin/activate
(venv)$
```

Create the `default.yml` for ansible variables

```shell
(venv)$ cat default.yml
HUB_RG:  ... # hub resource group. It should already exist
HUB_SUB: ... # hub azure subscription. It should already exisist
HUB_PDNSZ: ... # hub dns zone. It should be the private DNS zone of the HUB

STORAGE_RESOURCEGROUP: ... # storage resource group. It should already exist
STORAGE_CONTAINER: ... # azure storage container. Eventually it will be crated
STORAGE_ACCOUNT: ... # azure storage account. Eventually it will be created
STORAGE_SUBSCRIPTION: ... # azure subscription. It will be created it can be the subscription of the HUBs
```

then run the ansible playbook:

```shell
(venv)$ansible-playbook playbooks/enable-backup.yml  -e"@default.yml"
```


## Configure and run restore


Enter in `Python` virtual environment

```shell
$source venv/bin/activate
(venv)$
```

Create the `default.yml` for ansible variables

```shell
(venv)$ cat default.yml
HUB_RG:  ... # hub to restore resource group
HUB_SUB: ... # hub to restore azure subscription
HUB_PDNSZ: ... # hub to restore private dns zone

OLD_HUB_PDNSZ: ... # hub backed up private dns zone


STORAGE_RESOURCEGROUP: ... # storage resource group
STORAGE_CONTAINER: ... # azure storage container
STORAGE_ACCOUNT: ... # azure storage account
STORAGE_SUBSCRIPTION: ... # azure subscription
```

then run the ansible playbook:

```shell
(venv)$ansible-playbook playbooks/restore-hub.yml  -e"@default.yml"
```
