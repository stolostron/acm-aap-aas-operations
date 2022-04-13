#!/bin/sh

printf "=====================Create Openshift Gitops Subscription...\n"
kubectl apply -k ./cluster-bootstrap/openshift-gitops/deploy
sleep 10

printf "=====================Create and config Openshift Gitops instance with Vault plugin configed...\n"
kubectl apply -k ./cluster-bootstrap/openshift-gitops/config

printf "=====================Waiting for Openshift Gitops start up and running...\n"
kubectl wait --for=condition=Ready pods --all -n openshift-gitops --timeout=5m
printf "=====================Openshift Gitops deploy successful!\n"

printf "=====================Use the following info to login Openshift Gitops web console:\n"
printf "Web console URL: "
kubectl get route openshift-gitops-server -n openshift-gitops -o 'jsonpath={.spec.host}'
printf "\n"
printf "# admin.username\n"
printf "admin\n"
oc extract secret/openshift-gitops-cluster -n openshift-gitops --to=-

printf "=====================Create ACM Argocd application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/acm -n openshift-gitops
sleep 10

printf "=====================Create MultiCluster Observability Argocd application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/multicluster-observability -n openshift-gitops

printf "=====================Create Grafana-dev Argocd application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/grafana-dev -n openshift-gitops
sleep 10

printf "=====================Create Prometheus config Argocd application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/prometheus-config
sleep 10

printf "Cluster bootstrap completed with ACM, MultiCluster Observability, Grafana-dev, Prometheus config and custom Alters & Metrics!"
