# Red Hat Advanced Cluster Management for Kubernetes

This application will deploy the Red Hat Advanced Cluster Management for Kubernetes operator.

## Applying Prereqs

First, you need to provide an OCP pull secret (multiclusterhub-operator-pull-secret) on your cluster as follows:
1. `cp multiclusterhub-operator-pull-secret.secret.example multiclusterhub-operator-pull-secret.secret` and edit the file to contain your raw OCP pull secret contents
2, You should also fill `github.secret` copying it from `github.secret.example` (you may want to use what you may have already fill for `group-sync`.
3. `oc apply -k ./prereqs`

## Deploying this Application

To deploy this application, simply `oc apply -k ./gitops-applications/red-hat-advanced-cluster-management` from the root of this project (after configuring your github.secret as described in the [README](../../gitops-applications/red-hat-advanced-cluster-management/README.md)).
