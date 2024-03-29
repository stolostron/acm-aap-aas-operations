# [playbooks](playbooks/)
- [aap-controller-workflow-setup.yml](#controller-workflow)
- [bastion.yml](#bastion)
- [create-kubeconfig.yml](#create-kubeconfig)
- [operator-mgmt.yml](#operator-mgmt)
- [automation-test-reset.yml](#automation-test-reset)
- [deploy-acm-stack.yml](#deploy-acm-stack)

## <a name="controller-workflow"></a>[aap-controller-workflow-setup.yml](playbooks/aap-controller-workflow-setup.yml)
Playbook that setups an AAP controller from scratch to configure the workflows to deploy an hub.
Prerequisites:
* a configuration file with the proper name in playbooks/vars for any non secret configuration. This contains also the address of an Azure Key Vault
* in this Key Vault, you need 1 secret that contains a Base64 encoded string with the following content:
```
# AAP credentials
admin_username: 
admin_password: 
inventory_hostname:
# Azure credentials 
client_id: 
client_secret: 
tenant_id: 
subscription_id: 
# VM/OCP4 parameters
ssh_username: "az-admin"
public_ssh_key: <clear>
private_ssh_key: <base64 encoded>
ocp4_pull_secret: |-
    '<content>'
# Subscription for RHEL
rhsm_username: ""
rhsm_password: ""
# Argocd vault
argocd_vault_uri: ""
argocd_vault_token: ""
```

Playbook can then be used with this:
```
ansible-playbook ansible-playbooks/playbooks/aap-controller-workflow-setup.yml -e target=openshiftdev
```

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
## <a name="bastion"></a>[bastion.yml](playbooks/bastion.yml)
This playbook is meant to be run on bastion hosts, retrieved by the custom inventory defined [here](inventory/vm_inventory_azure_rm.yml).

It is split in 3 roles:
- user setup
- VM setup (RHEL registration configuration)
- OCP customization

They can be used separately by using tags.
### Configuration
- Public keys are in its own [var file](roles/authorized-key/vars/main.yml)
- Red Hat account for the subscription needs to be defined [here](roles/bastion-setup/vars/main.yml)

### Example
```
ansible-playbook -i ansible-playbooks/inventories/vm-inventory_azure_rm.yml ansible-playbooks/playbooks/bastion.yml -t vm -e "{\"rhsm_username\":\"USERNAME\",\"rhsm_password\":\"PASSWORD\"}"
ansible-playbook -i ansible-playbooks/inventories/vm-inventory_azure_rm.yml ansible-playbooks/playbooks/bastion.yml -t users
```
## <a name="import-collection"></a>[import-aap-aks-collection.yml](playbooks/import-aap-aks-collection.yml)

This is the first example playbook to import an aks cluster using `az aks command invoke` and standard priviledged service account on RHACM.

- a version that uses the generic import manifests
- a version that leverages direct aks k8s api connection (no aks command invoke)

To import with this playbook:

1. you need to be in the AOC subscription
```bash
az login --tenant RHAAPDEV....
```

2. you need to have oc command into the ACM cluster
```bash
oc login -u kubeadmin -p XXX -s https://api.acm.XXX:6443
```

3. run these commands

```bash
git clone ...
cd acm-aap-aas-operations/ansible-playbooks
make venv
source venv/bin/activate

# create the vars file and populate with your aks information
ansible-playbook playbooks/import-aap-aks.yml -e "@default.yml"
```

Use the ansible collection version of the playbook

```bash
# import managed application using ansible module
# NOTE: until we add the private link from AAP to the ACM hub, we have to continue to use command-invoke
ansible-playbook playbooks/import-aap-aks-collection.yml -e "@default.yml"

# delete/cleanup to start rerun import
ansible-playbook playbooks/import-aap-aks-collection.yml -e "@default.yml" -e delete=true
```

## Add a vars/default.yml file

In this first iteration, we reference the target AKS cluster with the variables. The ACM hub cluster information can be static.
Here, I create this file called `./vars/default.yml` and put it into vars.

The `./vars/default.yml` should not be checked in.

```yaml
# file ./vars/default.yml
#
# hub side variables. These will mostly be static.
HUB_RG: acm-dev-6wbm8-rg                 # resource group of the ACM hub cluster
HUB_SUB: 4da397a2-...                    # hub scription id
HUB_PDNSZ: hub.private.dnszone...        # private dns zone domain string

# target spoke variables
AKS_MRG: mrg-...-preview-20220331094426  # managed application resource group name
AKS_NAME: aks-...-centralus              # AKS k8s service name
AKS_SUB: e47e6908-...                    # subscription id of the AKS cluster
managed_application: acmaocdevtest0418   # name of the managed application, we'll add this label to the managed cluster CR
```

## <a name="deploy-acm-stack"></a>[deploy-acm-stack.yml](playbooks/deploy-acm-stack.yml)
Deploy hub cluster with ACM stacks and configurations for monitoring.

ENV values: `testing` | `dev` | `prod`

* `testing` will be our default ENV setting. All our deployments should use testing.
* `dev` is restricted to the current `acm1` cluster deployed in RHAAPDEV. This will have alertmanager setting to send alerts to the AOC channel.
* `prod` is restricted to the current `acm10` cluster deployed in RHAAP. 

### Example to deploy prod hub cluster
```
export KUBECONFIG=/path/to/kubeconfig

ansible-playbook playbooks/deploy-acm-stack.yml -e "ENV=testing VAULT_ADDRESS=<VAULT_ADDRESS> VAULT_TOKEN=<VAULT_TOKEN>"
```
