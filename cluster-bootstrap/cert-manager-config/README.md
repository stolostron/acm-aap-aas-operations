## Patching Cert-Manager

To accomodate OpenShift clusters' DNS Zone configurations, you need to patch the cert-manager CSV to use only recursive DNS servers.  To carry out this patch, run `./patch/patch-certmanager.sh` (path relative to this file).  

## Post-install/Creating CertificateIssuers and Certificates

Once you've deployed Cert-Manager, you have to create CertificateIssuers endowed with Cloud Platform credentials (AWS and Azure currently supported via this application) in order to issue Certificates using LetsEncrypt.  This process is codified in a simple `./postinstall` module (relative to this file).  

To configure and deploy CertificateIssuers and Certificates on your cluster, simply do the following:
1. Edit [postinstall/kustomization.yaml](./postinstall/kustomization.yaml) to include your clusters' `api` and `*.apps` domains in place of the current values in the patchesJson6902 block.  
2. Edit [postinstall/kustomization.yaml](./postinstall/kustomization.yaml) to add/remove the AWS or Azure issuer form the resources list to match the cloud platform where your Hub cluster is running.
3. Copy the <aws/azure>.secret.example file from [posinstall/aws-issuer](postinstall/aws-issuer) or [postinstall/azure-issuer](postinstall/azure-issuer) folders to <aws/azure>.secret and fill in the credentials.  
4. `oc apply -k ./postinstall` (from this README's directory) to create the CertificateIssuer for your cloud platform along with the relevant certificates.  
5. Run `./postinstall/setup-certs-on-cluster.sh` to configure your clusters' ingress to use the newly-issued `*.apps` certificate.  
