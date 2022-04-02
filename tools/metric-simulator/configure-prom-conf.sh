#!/bin/bash

OBS_NS="open-cluster-management-addon-observability"

kubectl get cm -n $OBS_NS prometheus-k8s-config
if [ $? -ne 0 ]; then
    echo "Failed to get prometheus-k8s-config configmap"
    exit 1
fi

kubectl get cm -n $OBS_NS prometheus-k8s-config -o json | jq '.data."prometheus.yaml"' -r > prometheus.yaml

cat << EOF >> prometheus.yaml
- job_name: metric-simulator
  honor_labels: false
  kubernetes_sd_configs:
  - role: endpoints
    namespaces:
      names:
      - open-cluster-management-addon-observability
  scrape_interval: 30s
  metrics_path: /metrics
  scheme: http
EOF

kubectl delete cm -n $OBS_NS prometheus-k8s-config
kubectl create cm -n $OBS_NS prometheus-k8s-config --from-file prometheus.yaml
if [ $? -ne 0 ]; then
    echo "Failed to update prometheus-k8s-config configmap"
    exit 1
fi
