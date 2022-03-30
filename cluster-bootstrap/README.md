# ACM AAP monitoring hub cluster bootstrap

This folder contains the artifacts with conrfiguration and related Argocd applications that helps to deploy ACM hub management layer on top of the AAPaaS offering.

## Deploying Hub Services on a New Cluster

Prerequisites:
Make sure all secrets(path and key) are put in Vault defore the deployment. Please refer to the secret defination doc here:
https://docs.google.com/document/d/1E5n62ed9-ls3rIIPqd8SoTM2W9OzC6xQTq6jQc11fsA/edit


1. Deploy OpenShift GitOps. Replace the `VAULT_ADDRESS` and `VAULT_TOKEN` with the Vault service address and auth token. 
   Then run `kubectl apply -k ./cluster-bootstrap/openshift-gitops/deploy` and run `kubectl apply -k ./cluster-bootstrap/openshift-gitops/config`.

2. Deploy ACM. Run `kubectl apply -k ./cluster-bootstrap/argocd-apps/acm -n openshift-gitops`.

3. Deploy MultiCluster Observability. Run `kubectl apply -k ./cluster-bootstrap/argocd-apps/multicluster-observability -n openshift-gitops`.

4. Deploy Grafana dev. `kubectl apply -k ./cluster-bootstrap/argocd-apps/grafana-dev -n openshift-gitops`.

5. Deploy Prometheus config. `kubectl apply -k ./cluster-bootstrap/argocd-apps/prometheus-config`
