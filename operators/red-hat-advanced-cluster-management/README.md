# Deploying this App

This application will deploy the Ansible Automation Platform 2.Y operator via a subscription and then deploy the Automation Controller and Automation Hub components.  You can configure these resources by editing their yaml before deploying this direcotry as an application in ArgoCD.  

To deploy this folder as an application, you **have to apply prerequisites first**.  

## Prereqs

Before you configure this application, you need to set up an S3 bucket for your RWX storage provider (if you wish to use this storage type, which I recommend for AWS-based clusters), create the operator's namespace, and create a secret to provide access to this S3 bucket.  This process is documented in the [prereqs README](.prereqs/README.md).  

## Application

Once you've fulfilled the prereqs, you can configure this application like usual in ArgoCD - but you can **only** configure an application for this folder in non-recursive mode.  ArgoCD doesn't support recursive mode _and_ Kustomize, which is used by this folder.  

Make sure to edit the [subscription.yaml](./subscription.yaml) to point to the correct startingCSV, channel, etc.  

Once you make any edits you want to the subscription, channel, and yamls and you're off to the races!  