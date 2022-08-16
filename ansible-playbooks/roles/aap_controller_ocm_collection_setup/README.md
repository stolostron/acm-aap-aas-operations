# aap_controller_ocm_collection_setup
This role configures a minimal setup to run the stolostron.ocm collection. Secrets are taken from an Azure Key Vault and the target is an AAP controller instance.

- Input: Azure Key Vault *vault_uri* containing a secret named acm-sre-{{ target }}-secrets and one named acm-sre-{{ target }}-aap-import-token
- Target: *controller_host*

# Usage

```
ansible-playbook playbooks/aap-controller-ocm-collection-setup.yml -e target=pn -e tenant_name=pn
```
where target must be one of the files in vars folder.

## Advanced options
```
-vv for debugging
```

Any variable can be overridden by explicitly passing it to command line call. Otherwie, they are taken from the corresponding profile matched by target.

# Dependencies
Secrets with the expected names are available in the target Azure Key Vault.

# Requirements
* azure collection in the local env
* awx collection in the local env
* Local user is either connected to the target Azure Key Vault with CLI or there is a Service Principal with access rights to the KV in ~/.azure/credentials
