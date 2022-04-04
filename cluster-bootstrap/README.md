# ACM AAP monitoring hub cluster bootstrap

This folder contains the artifacts with configuration and related Argocd applications that helps to deploy ACM hub management layer on top of the AAPaaS offering.

## Deploying Hub Services on a New Cluster

Prerequisites:
Make sure all secrets(path and key) are put in Vault before the deployment. Please refer to the secret definition doc here:
https://docs.google.com/document/d/1E5n62ed9-ls3rIIPqd8SoTM2W9OzC6xQTq6jQc11fsA/edit


Deployment:

1. Replace the `VAULT_ADDRESS` and `VAULT_TOKEN` in `cluster-bootstrap/openshift-gitops/config/argocd.yaml` with the Vault service address and auth token which are available in above doc.

2. Run `make deploy-dev-all`.
