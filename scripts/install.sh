#!/bin/sh

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

printf "=====================Create ACM Argocd application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/acm -n openshift-gitops

printf "=====================Create MultiCluster Observability Argocd application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/multicluster-observability -n openshift-gitops

printf "=====================Create Grafana-dev Argocd application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/grafana-dev -n openshift-gitops

printf "=====================Create Prometheus config Argocd application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/prometheus-config

printf "=====================Create Cert-manager application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/cert-manager

printf "=====================Create Patch-operator application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/patch-operator

printf "=====================Create openshift-config application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/openshift-config

printf "Cluster bootstrap completed with ACM, MultiCluster Observability, Grafana-dev, Prometheus config and custom Alters & Metrics!\n\n"
