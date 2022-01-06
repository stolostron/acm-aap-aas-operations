# Red Hat Advanced Cluster Management for Kubernetes

This application will deploy the MultiClusterObservability operator under RHACM.  

## Applying Prereqs

First, you need to provide an OCP pull secret (multiclusterhub-operator-pull-secret) and StorageAccount on Azure as follows:
1. Log in to Azure and create a new StorageAccount, default settings are sufficient, taking note of the name.
2. View and copy the storage account's secret/key from the StorageAccount object on Azure, `cp thanos.yaml.secret.example thanos.yaml.secret`, and populate `thanos.yaml.secret` with the StorageAccount name and Secret/Key.  
3. `cp multiclusterhub-operator-pull-secret.secret.example multiclusterhub-operator-pull-secret.secret` and edit the file to contain your raw OCP pull secret contents
4. `oc apply -k ./prereqs`

## Deploying this Application

To deploy this application, simply `oc apply -k ./gitops-applications/multiclusterobservability` from the root of this project (after configuring your github.secret as described in the [README](../../gitops-applications/multiclusterobservability/README.md)).  
