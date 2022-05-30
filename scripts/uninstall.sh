#!/bin/sh

argocd_apps=("alert-manager-config" "alertmanager-to-github" "sso" "group-sync" "openshift-config" "patch-operator" "prometheus-config" "grafana-dev" "multicluster-observability" "acm")
for app in "${argocd_apps[@]}"; do
    kubectl patch app $app  -p '{"metadata": {"finalizers": ["resources-finalizer.argocd.argoproj.io"]}}' --type merge -n openshift-gitops
    kubectl delete app $app -n openshift-gitops
    printf "✓ $app deleted \n"
done
