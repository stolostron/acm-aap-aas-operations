# ACM AAP monitoring hub cluster bootstrap

This folder contains the artifacts with configuration and related Argocd applications that helps to deploy ACM hub management layer on top of the AAPaaS offering.

## Deploying Hub Services on a New Cluster


### Prerequisites:
Please check the following doc which contains the tokens need to use during the cluster bootstrap deployment.
https://docs.google.com/document/d/1E5n62ed9-ls3rIIPqd8SoTM2W9OzC6xQTq6jQc11fsA/edit


### Deployment:
1. Replace the `VAULT_ADDRESS` and `VAULT_TOKEN` in `cluster-bootstrap/openshift-gitops/config/argocd.yaml` with the Vault service address and read only auth token from above doc. Please take care of using the correct env values for your deployment. 
2. Run `make deploy-testing` to deploy a testing hub cluster.

### How to setup your own customized config cluster for testing
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
    │       ├── prod
    │       ├── prod-emea
    │       ├── testing 
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
    │       ├── prod
    │       ├── prod-emea
    │       ├── testing         
    │       └── local                   
    ├── cert-manager-config                 # Cert manager configuration with public issuer
    │   ├── base
    │   └── overlay
    │       ├── dev  
    │       ├── prod
    │       ├── prod-emea
    │       ├── testing                          
    │       └── stage            
    ├── alert-manager-config                # Deploy Alert manager policy configuration
    │   ├── base
    │   └── overlay
    │       ├── dev                            
    │       ├── prod
    │       ├── prod-emea
    │       ├── testing
    │       └── local
    ├── grafana-dev                         # Deploy Grafana dev instance configuration
    │   ├── base   
    │   └── overlay
    │       ├── dev  
    │       ├── prod
    │       ├── prod-emea
    │       ├── testing
    │       └── local
    ├── group-sync                          # Deploy Group Sync operator to auto sync the teams
    │   ├── base   
    │   └── overlay
    │       ├── dev
    │       ├── prod
    │       ├── prod-emea
    │       └── testing
    ├── multicluster-observability
    │   ├── base
    │   │   ├── custom-alerts                # Custom alerts configuration
    │   │   ├── custom-metrics               # Custom metrics configuration
    │   │   ├── dashboard                    # Custom Grafana dashboard configuration
    │   │   └── deploy                       # Deploy Multicluster observability
    │   └── overlay  
    │       ├── dev
    │       ├── prod
    │       ├── prod-emea
    │       ├── testing    
    │       └── local
    ├── openshift-config                     # Config patch and upgrade policy OCP 
    │   ├── base                             
    │   └── overlay  
    │       ├── dev
    │       ├── prod
    │       ├── prod-emea
    │       ├── testing    
    │       └── local
    ├── openshift-gitops                     # Config Argocd to manage itself 
    │   ├── base
    │   ├── config
    │   ├── deploy                                 
    │   └── overlay  
    │       ├── dev
    │       ├── prod
    │       ├── prod-emea
    │       └── testing
    ├── patch-operator                       # Deploy patch-operator
    │   ├── base                             
    │   └── overlay  
    │       ├── dev
    │       ├── prod
    │       ├── prod-emea
    │       ├── testing   
    │       └── local        
    ├── prometheus-config                    # Deploy Prometheus configuration
    │   ├── base                             
    │   └── overlay  
    │       ├── dev
    │       ├── prod
    │       ├── prod-emea
    │       ├── testing       
    │       └── local
    └── sso                                  # Deploy SSO based on github idp
        ├── base                             
        └── overlay
            ├── prod
            ├── prod-emea
            ├── testing               
            └── dev
