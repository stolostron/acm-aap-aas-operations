# Deploying this App

This application will deploy the Ansible Automation Platform 2.Y operator via a subscription and then deploy the Automation Controller and Automation Hub components.  You can configure these resources by editing their yaml before deploying this direcotry as an application in ArgoCD.  

To deploy this folder as an application, you **have to apply prerequisites first**.  

## Prereqs

Before you configure this application, you need to set up an S3 bucket for your RWX storage provider (if you wish to use this storage type, which I recommend for AWS-based clusters), create the operator's namespace, and create a secret to provide access to this S3 bucket.  This process is documented in the [prereqs README](.prereqs/README.md).  

## Application

Once you've fulfilled the prereqs, simply `oc apply -k gitops-applications/ansible-automation-platform` from the root of this project (after configuring your github.secret as described in the [README](../../gitops-applications/ansible-automation-platform/README.md)).  