# Red Hat Advanced Cluster Management for Kubernetes

This application will deploy the Identity Configuration Management for Kubernetes Operator and Operands.  

## Deploying this Application

To deploy this application, simply `oc apply -k ./gitops-applications/identity-configuration-management-for-kubernetes` from the root of this project (after configuring your github.secret as described in the [README](../../gitops-applications/identity-configuration-management-for-kubernetes/README.md)).  This will _only_ deploy the operator using a pre-GA, OpenShift 4.9-friendly version.  You'll need to do some postinstall steps to configure the AuthRealm.  

## Post-install Steps

1. Create a GitHub OAuth Application.  In your GitHub organization, create a new OAuth Application with the Homepage URL: `https://console-openshift-console.apps.<cluster-url>` and Authorization Callback URL: `https://primary.apps.<cluster-url>/callback`.  
2. Edit [postinstall/kustomization.yaml](./postinstall/kustomization.yaml)'s patchesJson6902 to contain your GitHub OAuth Application's Client ID.  
3. `cp ./postinstall/github-clientsecret.secret.example ./postinstall/github-clientsecret.secret` and edit the file to contain a generated client secret for your GitHub OAuth Application.  
4. `oc apply -k ./postinstall`
5. `oc label managedcluster local-cluster cluster.open-cluster-management.io/clusterset=primary-authrealm-clusterset` and `oc label managedcluster local-cluster authdeployment=primary` and your authentication provider should start rolling out to the local cluster.  
