# Automate private RHACM with private AKS clusters

Goal of this document is document the various steps to configure the _Backup_ and the _Restore_  for *Private* RHACM Hub managing *private* AKS clusters. Here we supply _Ansible_ playbooks to automate the two processes

## Prerequirements

An Azure storage account with a container need to be configured and supplied tofor both backup and restore, no need to be created in the same reosurce group and subscription but then the RBAC has to be changed accordingly.

### Creating stroage account



```shell
$ az storage account create --name ${STORAGE_ACCOUNT} -l eastus --sku Standard_LRS -g ${STORAGE_RESOURCEGROUP} --subscription ${STORAGE_SUBSCRIPTION}
$ STORAGEKEY=$(az storage account keys list --account-name ${STORAGE_ACCOUNT} -g ${STORAGE_RESOURCEGROUP} --subscription ${STORAGE_SUBSCRIPTION} --query [0].value -o tsv)
$ cat << EOF > storage.secret
AZURE_STORAGE_ACCOUNT_ACCESS_KEY=${STORAGEKEY}
AZURE_CLOUD_NAME=AzurePublicCloud
EOF
```


oc create secret generic cloud-credentials --namespace openshift-adp --from-file cloud=storage.secret
