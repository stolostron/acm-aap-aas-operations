#!/bin/sh

printf "=====================Create Openshift Gitops Subscription...\n"
kubectl apply -k ./cluster-bootstrap/openshift-gitops/deploy

printf "=====================Waiting for default Openshift Gitops instance terminating, as Openshift Gitops will create a default instance immediately after subscription created....\n"
sleep 90
while [[ $(kubectl get pod -n openshift-gitops --output name | wc -l) > 2 ]]; do echo "Still need to wait default instance terminating" && sleep 10; done

printf "=====================Create and config Openshift Gitops instance with Vault plugin configed...\n"
kubectl apply -k ./cluster-bootstrap/openshift-gitops/config
sleep 10

printf "=====================Waiting for Openshift Gitops start up and running...\n"
kubectl wait --for=condition=Ready pods --all -n openshift-gitops
echo "=====================Openshift Gitops deploy successful!"

printf "=====================Patch Openshift Gitops Subscription to enable default instance which will prevent the custom instance we created to be deleted by operator ...\n"
oc patch subs openshift-gitops-operator -n openshift-operators --type=json --patch '
[
  {
    "path": "/spec/config/env/0",
    "op": "replace",
    "value": {
      "name": "DISABLE_DEFAULT_ARGOCD_INSTANCE",
      "value": "false"
    }
  }
]
'

printf "=====================Use the following info to login Openshift Gitops web console:\n"
printf "Web console URL: "
kubectl get route openshift-gitops-server -n openshift-gitops -o 'jsonpath={.spec.host}'
printf "\n"
printf "# admin.username\n"
printf "admin\n"
oc extract secret/openshift-gitops-cluster -n openshift-gitops --to=-

echo ""

printf "=====================Create ACM Argocd application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/acm -n openshift-gitops
sleep 10

printf "=====================Create MultiCluster Observability Argocd application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/multicluster-observability -n openshift-gitops

printf "=====================Create Grafana-dev Argocd application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/grafana-dev -n openshift-gitops
sleep 10

printf "=====================Create Prometheus config Argocd application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/prometheus-config
sleep 10

echo "Cluster bootstrap completed with ACM, MultiCluster Observability, Grafana-dev, Prometheus config and custom Alters & Metrics!"
