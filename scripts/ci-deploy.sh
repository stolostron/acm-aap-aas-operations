#!/bin/sh
set -e

_cloud_provider=$1
_GITREPO=$2
_GITBRANCH=$3
_GITCOMMIT=$4
_GITCOMMIT_SHORT=${_GITCOMMIT:0:5}

mkdir -p samples/
cd samples/
git clone --single-branch --branch "${_GITBRANCH}"  https://github.com/${_GITREPO}.git
cd acm-aap-aas-operations/

echo "== Deploying ACM-AAP-AAS-Operations to ${_cloud_provider}..."

# Check if cloud provider is valid. Perhaps support AKS next.
if [[ "$_cloud_provider" == "aws" ]]; then
    oc login ${_AWS_CLUSTERPOOL_API_URL} --insecure-skip-tls-verify --token="${_AWS_CLUSTERPOOL_TOKEN}"
    oc project managed-services
    _PIPELINERUN_NAME=deploy-acm-aap-aas-ops-dev-${_GITCOMMIT_SHORT}
      
    _PIPELINERUN_NAME=${_PIPELINERUN_NAME} yq eval -i '.metadata.name = env(_PIPELINERUN_NAME)' scripts/ci-deploy-resources/pipelinerun.yaml
    _GITREPO=https://github.com/${_GITREPO}.git yq eval -i '.spec.params |= map(select(.name == "gitRepo").value = env(_GITREPO))' scripts/ci-deploy-resources/pipelinerun.yaml
    _GITBRANCH=${_GITBRANCH} yq eval -i '.spec.params |= map(select(.name == "gitBranch").value = env(_GITBRANCH))' scripts/ci-deploy-resources/pipelinerun.yaml  
    echo ""
    echo "Creating the following PipelineRun -"
    echo ""
    oc delete pipelinerun ${_PIPELINERUN_NAME} || true
    cat scripts/ci-deploy-resources/pipelinerun.yaml  
    cat scripts/ci-deploy-resources/pipelinerun.yaml  | oc apply -f -
    echo ""
    echo "View Pipeline run here - ${_AWS_CLUSTERPOOL_CONSOLE_URL}/k8s/ns/managed-services/tekton.dev~v1beta1~PipelineRun/${_PIPELINERUN_NAME}"

    _ATTEMPTS=0
    until oc get pipelinerun ${_PIPELINERUN_NAME} -n managed-services -ojsonpath='{.status.conditions[].reason}' | grep "Succeeded";
    do 
        echo "${_ATTEMPTS}/90: Waiting for the Pipeline to complete..."
        _ATTEMPTS=$((_ATTEMPTS + 1))
        sleep 60;
        if [[ $_ATTEMPTS == 90 ]]; then
            echo "The Pipeline failed to complete in the allotted time"
            exit 1
        fi
    done

else
  echo "Invalid cloud provider. Exiting."
  exit 1
fi
