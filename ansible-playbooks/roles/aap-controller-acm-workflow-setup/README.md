# aap-controller-acm-workflow-setup
This role setups an AAP controller with ACM related workflows. It takes in input an Azure Key Vault and targets an AAP controller instance.

Currently we support:

- Input: Azure Key Vault *vault_uri* containing a secret named acm-sre-{{ target }}-secrets
- Target: *controller_host*

# Usage

```
ansible-playbook ansible-playbooks/playbooks/aap-controller-workflow-setup.yml -e target=openshiftdev
```
where target must be one of the files in vars folder.

## Advanced options
```
-vv for debugging
```

Any variable can be overridden by explicitly passing it to command line call. Otherwie, they are taken from the corresponding profile matched by target.

# Dependencies
Secrets are available in the target Azure Key Vault (either manually or by calling aap-controller-acm-workflow-secret-sync).

# Requirements
* az collection in the local env
* awx collection in the local env
* Local user is either connected to the target Azure Key Vault with CLI or there is a Service Principal with access rights to the KV in ~/.azure/credentials
