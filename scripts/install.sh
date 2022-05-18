#!/bin/sh

generate_pull_secret()
{
source ./scripts/local-install.env
TMP_DIR=$(mktemp -d)
echo $TMP_DIR
cd $TMP_DIR
cat > ./kustomization.yaml <<-EOF 
generatorOptions:
  disableNameSuffixHash: true
namespace: open-cluster-management
secretGenerator:
- name: multiclusterhub-operator-pull-secret
  type: "kubernetes.io/dockerconfigjson"	
  literals:
    - .dockerconfigjson=$PULL_SECRET
EOF
kubectl create namespace open-cluster-management --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -k .
cd - && rm -rf $TMP_DIR
}

printf "=====================Create Openshift Gitops Subscription...\n"
kubectl apply -k ./cluster-bootstrap/openshift-gitops/deploy

while [[ $(kubectl get ns openshift-gitops --no-headers --ignore-not-found | wc -l) -eq 0 ]]; 
    do echo "Waiting for openshift-gitops namespace to be created" && sleep 30;
done

printf "=====================Waiting for Openshift Gitops start up and running...\n"
kubectl wait --for=condition=Ready pods --all -n openshift-gitops --timeout=5m
printf "=====================Openshift Gitops deploy successful!\n"

printf "=====================Create and config Openshift Gitops instance with Vault plugin configed...\n"
kubectl apply -k ./cluster-bootstrap/openshift-gitops/config

printf "=====================Waiting for configured Gitops repo server up and running...\n"
kubectl wait --for=condition=Ready pods --all -n openshift-gitops --timeout=5m
printf "=====================Openshift Gitops deploy successful!\n"

printf "=====================Use the following info to login Openshift Gitops web console:\n"
printf "Web console URL: https://"
kubectl get route openshift-gitops-server -n openshift-gitops -o 'jsonpath={.spec.host}'
printf "\n"
printf "# admin.username\n"
printf "admin\n"
oc extract secret/openshift-gitops-cluster -n openshift-gitops --to=-
sleep 10

while [[ $(kubectl get pods -n openshift-gitops --no-headers --ignore-not-found | awk '/openshift-gitops-repo-server/' | wc -l) -ne 1 ]]; 
    do echo "Waiting for openshift-gitops-repo-server with vault plugin start up and running" && sleep 30;
done

if [ $1 == "local" ]; then
    generate_pull_secret
fi
printf "=====================Create ACM Argocd application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/acm -n openshift-gitops

printf "=====================Create MultiCluster Observability Argocd application ...\n"
if [ $1 == "local" ]; then
    source ./scripts/local-install.env
    generate_pull_secret
    sed -i'' 's/<S3_BUCKET_NAME>/'$S3_BUCKET_NAME'/g;s/<S3_ENDPOINT>/'$S3_ENDPOINT'/g;s/<AWS_ACCESS_KEY>/'$AWS_ACCESS_KEY'/g;s/<AWS_SECRET_KEY>/'$AWS_SECRET_KEY'/g' ./cluster-bootstrap/multicluster-observability/overlay/local/thanos-storage-aws-secret.yaml
    kubectl create namespace open-cluster-management-observability --dry-run=client -o yaml | kubectl apply -f -
    kubectl apply -f ./cluster-bootstrap/multicluster-observability/overlay/local/thanos-storage-aws-secret.yaml
fi
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/multicluster-observability -n openshift-gitops

printf "=====================Create Grafana-dev Argocd application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/grafana-dev -n openshift-gitops

printf "=====================Create Prometheus config Argocd application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/prometheus-config

printf "=====================Create Patch-operator application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/patch-operator

printf "=====================Create openshift-config application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/openshift-config

printf "✓ Cluster bootstrap completed with ACM, MultiCluster Observability, Grafana-dev, Prometheus config and custom Alters & Metrics!\n\n"
