# Creating the Pre-Requisite Pull Secret for ACM

Red Hat Advanced Cluster Management requires a pull secret for OpenShift that will be copied to managed clusters so ACM components can be pulled.  

To create this secret:
1. Ensure that the prereqs kustomize and the red-hat-advanced-cluster-management kustomize `namespace` entries match.  
2. Log in to the cluster where you wish to deploy this app.  
3. `cp env.secret.example env.secret` and fill out the details, namely the secret with your OpenShift pull secret.
4. `oc apply -k .` in this folder to create the secret.  
