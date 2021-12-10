# Prereequisites

You can't start rolling out OpenShift GitOps applications for Operators and Configurations without OpenShift GitOps first - this folder contains a folder to deploy the [OpenShift GitOps Operator](./openshift-gitops-operator) and [configuration for the GitOps instance and RBAC behind ArgoCD](./openshift-gitops-configuration).  

## Deployment

To deploy the operator and configuration in this repo:
1. Log in to the target cluster
2. `oc apply -f ./openshift-gitops-operator`
3. Wait for the OpenShift GitOps Operator to signal ready (monitoring via the UI or `oc get operators`)
4. `oc apply -f ./openshift-gitops-configuration`