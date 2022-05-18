# ACM AAP monitoring hub cluster bootstrap

This folder contains the artifacts with configuration and related Argocd applications that helps to deploy ACM hub management layer on top of the AAPaaS offering.

## Deploying Hub Services on a New Cluster


### Prerequisites:
Please check the following doc which contains the tokens need to use during the cluster bootstrap deployment.
https://docs.google.com/document/d/1E5n62ed9-ls3rIIPqd8SoTM2W9OzC6xQTq6jQc11fsA/edit


### Deployment:
1. Replace the `VAULT_ADDRESS` and `VAULT_TOKEN` in `cluster-bootstrap/openshift-gitops/config/argocd.yaml` with the Vault service address and read only auth token from above doc.
   Please take care of using the correct env values for your deployment.
   * Dev is for development env usage. 
2. Deploy the stacks:
   * For bootstrap a development env without alert forwarding, run `make deploy-dev-noalerts`.
   * For bootstrap development env, run `make deploy-dev`.
   * For bootstrap development env based on private cluster, run `make deploy-dev-private`.


### How to setup your own cluster for testing
1. Prepare your own OCP cluster, current you could resume one quickly from AWS cluster pool
2. Fork the repo and update all the `repoURL` in `application.yaml` under `./cluster-bootstrap/argocd-apps/local` with your forked URL
3. Fill in your tokens in `./scripts/local-install.env`. Notes: Please keep the quotes mark.
4. Run `make deploy-local`


### Configurations layout:
    cluster-bootstrap
    ├── acm                                 # Deploy ACM
    │   ├── base
    │   └── overlay                          
    │       ├── dev
    │       └── local                            
    ├── acm-app                             # Deploy ansible-automation-platform through ACM application channel
    │   ├── base
    │   └── overlay
    │       ├── dev                            
    ├── acm-channel                         # Deploy ACM application channel
    │   ├── base
    │   └── overlay
    │       ├── dev                            
    ├── cert-manager                        # Deploy Cert manager
    │   ├── base      
    │   └── overlay
    │       ├── dev                            
    ├── cert-manager-config                 # Cert manager configuration with public issuer
    │   ├── base
    │   └── overlay
    │       ├── dev                            
    │       └── stage            
    ├── alert-manager-config                # Deploy Alert manager policy configuration
    │   ├── base
    │   └── overlay
    │       ├── dev                            
    │       ├── dev-noalerts                # Disable alerting for DEV testing
    |       ├── dev-private                 # Add http proxy for slack alerts forwards
    │       └── local
    ├── grafana-dev                         # Deploy Grafana dev instance configuration
    │   ├── base   
    │   └── overlay
    │       ├── dev  
    │       ├── dev-managed-premium 
    │       └── local                           
    ├── multicluster-observability
    │   ├── base
    │   │   ├── custom-alerts                # Custom alerts configuration
    │   │   ├── custom-metrics               # Custom metrics configuration
    │   │   ├── dashboard                    # Custom Grafana dashboard configuration
    │   │   └── deploy                       # Deploy Multicluster observability
    │   └── overlay  
    │       ├── dev
    │       └── local
    └── prometheus-config                    # Deploy Prometheus configuration
        ├── base                             
        └── overlay  
            ├── dev
            └── local
