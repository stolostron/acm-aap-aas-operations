# aap-controller-acm-workflow-secret-sync
This role copies a list of secrets from a source to a destination. It is meant to bootstrap an Azure Key Vault secret

Currently we support:

- Input: Git repository defined with *acm_aoc_configuration_repo*
- Output: Azure Key Vault as a single secret defined with *vault_uri*

# Usage

```
ansible-playbook ansible-playbooks/playbooks/aap-controller-workflow-secrets.yml -e target=openshiftdev
```
where target must be one of the files in vars folder.

## Advanced options
```
-vv for debugging
```

Any variable can be overridden by explicitly passing it to command line call. Otherwie, they are taken from the corresponding profile matched by target.

# Dependencies
None

# Requirements
* connected to VPN for gitlab access
* az collection in the local env
* Local user is either connected to the target Azure Key Vault with CLI or there is a Service Principal with access rights to the KV in ~/.azure/credentials
