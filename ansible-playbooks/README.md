# [playbooks](playbooks/)
- [create-kubeconfig.yml](#create-kubeconfig)
- [operator-mgmt.yml](#operator-mgmt)
- [automation-test-reset.yml](#automation-test-reset)

## <a name="create-kubeconfig"></a>[create-kubeconfig.yml](playbooks/automation-test-reset.yml)
use to generate kubeconfig for the target clusters
artifacts for configuring the RBAC for the service account is located at [k8s-rbac](k8s-rbac/)

currently the playbook is hard coded to use RBAC artifacts that are defined in 
[k8s-rbac/cluster-admin](k8s-rbac/cluster-admin/)

**TODO:** allow specification of RBAC file/directory as var

currently the `ManagedServiceAccount` TTL is set to 3600 second (1hr)

**TODO:** allow specification of ManagedServiceAccount TTL as var

### Example
```
export K8S_AUTH_KUBECONFIG=/path/to/hub/kubeconfig

ansible-playbook playbooks/create-kubeconfig.yml -i inventories/cluster-inventory-example.yml -e target_hosts=dev-azure-aap
```

**output:**
[kubeconfig](kubeconfig/) directory will be created with kubeconfig files matche the `ManagedCluster` name for the `ManagedCluster`

```
kubeconfig
├── cicd-aap-aas-ansible-c-eastus
└── cicd-aap-aas-ansible-d-eastus
```

## <a name="operator-mgmt"></a>[operator-mgmt.yml](playbooks/operator-mgmt.yml)

manage operators and upgrade operators to it's desired version on all the selected clusters

the desire state for the operators is located in [k8s-operators](k8s-operators/) directory

to set which operators the playbook will manage modify this section in the playbook
```
        - include_role: 
            name: ../roles/k8s-operator-mgmt
          ignore_errors: yes
          with_items:
            - "../k8s-operators/automation-test"
            # - "../k8s-operators/ansible-automation-platform-operator"
            # - "../k8s-operators/cert-manager"
            # - "../k8s-operators/keycloak-operator"
            # - "../k8s-operators/nginx-ingress-operator"
```
**TODO:** allow configuration of target operator directory as var

### Example
```
export K8S_AUTH_KUBECONFIG=/path/to/hub/kubeconfig

ansible-playbook playbooks/operator-mgmt.yml -i inventories/cluster-inventory-example.yml -e target_hosts=dev-azure-aap
```

## <a name="automation-test-reset"></a>[automation-test-reset.yml](playbooks/automation-test-reset.yml)
delete the `automation-test` namespace on all selected cluster

### Example
```
ansible-playbook playbooks/automation-test-reset.yml -i inventories/cluster-inventory-example.yml -e target_hosts=dev-azure-aap
```


# Importing AKS Clusters

This is the first example playbook to import an aks cluster using `az aks command invoke` and standard priviledged service account on RHACM.

- a version that uses the generic import manifests
- a version that leverages direct aks k8s api connection (no aks command invoke)

To import with this playbook:

1. you need to be in the AOC subscription.
2. you need to have oc command into the ACM-DEV cluster.

3. run these commands...
```bash
git clone ...
cd acm-aap-aas-operations/ansible-playbooks

# create the vars file and populate with your aks information
ansible-playbook playbooks/import-aap-aks.yml -e @vars/default.yml
```

## Add a vars file

In this first iteration, we reference the target aks cluster with the variables.
The ACM hub cluster information can be static. Here, I create this file callled default.yml and put it into vars.
This default.yml need not be checked in.

```yaml
cluster_name: aks-...-centralus
AKS_MRG: mrg-...-preview-20220331094426
AKS_RG: aks-...-centralus
AKS_SUB: e47e6908-...
HUB_RG: acm-dev-6wbm8-rg
HUB_SUB: 4da397a2-...
```
