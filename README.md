# ACM AAPaaS Operations Repo

This repository contains artifacts, OpenShift GitOps applications, policy, conrfiguration, dashboards, and more - all involved with operating the ACM hub management layer on top of the AAPaaS offering.  

## Deploying a New Hub Using this Repository

This repository is currenlty a semi-manual deploy process, and will continue to require manual steps until we configure a shared vault instance for secret storage and injection.  

If you wish to deploy a new hub with all of the operators, services, and configurations present in this repository, you'll need to deploy each components pre-reqs, then the GitOps application itself and, in some cases, postinstall objects (like CRs that require secrets).  

The recommended order is as follows:
1. Deploy OpenShift GitOps by running `oc apply -k ./prereqs/openshift-gitops-operator` followed by `oc apply -k ./prereqs/openshift-gitops-configuration`.  
2. Deploy Cert-Manger.  The Cert-Manager prereqs and postinstall instructions can be found in the [cert-manager GitOps application README](./operators/cert-manager/README.md). 
3. Deploy Group-Sync.  The Group-Sync prereqs and postinstall instructions can be found in the [group-sync GitOps application README](./operators/group-sync/README.md).
4. Deploy Red Hat Advanced Cluster Management for Kubernetes.  The RHACM prereqs and install instructions can be found in the [RHACM GitOps application README](./operators/red-hat-advanced-cluster-management/README.md).  
5. Deploy MultiClusterObservability.  The Observability prereqs and install instructions can be found in the [MCO GitOps applicaton README](./operators/multiclusterobservability/README.md).
6. Deploy Identity Configuration Management for Kubernetes.  The IDP Config Management prereqs and postinstall instruciton can be found in the [IDP Config Management GitOps application README](./operators/identity-configuration-management-for-kubernetes/README.md).  
7. [OPTIONAL] Deploy Ansible Automation Platform to the Hub.  The AAP prereqs and install instructions can be found in the [AAP GitOps application README](./operators/ansible-automation-platform/README.md).  
8. [OPTIONAL] Deploy RBAC configurations to the hub.  To accomplish this, simply `oc apply -k ./gitops-applications/rbac` (after configuring your github.secret as described in the [README](../../gitops-applications/rbac/README.md)).  
