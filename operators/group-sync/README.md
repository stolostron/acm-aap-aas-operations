# Cert Manager GitOps Application

This application will deploy the the OpenSource Group-Sync operator and configure it to sync groups from a given GitHub organization.  

To deploy this folder as an application, you **have to apply prerequisites first**.  

## Applying Prereqs

First, you need to apply prereqs (namespace, GitHub secret) for the group-sync operator's operand:
1. `cp ./prereqs/github.secret.example ./prereqs/github.secret` and populate it wtih a valid GitHub token with access to the target github organization.
2. `oc apply -k ./prereqs`

## Deploying this Application

Edit `kustomization.yaml` to ensure that the patchesJson6902 patches in the correct GitHub organization, commit and push that file to your GitOps repo, then `oc apply -k ./gitops-applications/group-sync` from the root of this project (after configuring your github.secret as described in the [README](../../gitops-applications/group-sync/README.md)).  
