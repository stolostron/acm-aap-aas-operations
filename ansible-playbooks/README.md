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