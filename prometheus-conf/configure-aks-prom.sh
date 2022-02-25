#!/bin/bash

OBS_NS="open-cluster-management-addon-observability"
AAP_NS="ansible-automation-platform"

# ignore if the prometheus-k8s-config have updated
kubectl get cm -n $OBS_NS -lapp-configured=true | grep prometheus-k8s-config
if [ $? -eq 0 ]; then
    echo "prometheus-k8s-config have updated with AAP conf"
    exit 0
fi

kubectl get cm -n $OBS_NS prometheus-k8s-config
if [ $? -ne 0 ]; then
    echo "Failed to get prometheus-k8s-config configmap"
    exit 1
fi

kubectl get cm -n $OBS_NS prometheus-k8s-config -o json | jq '.data."prometheus.yaml"' -r > prometheus.yaml

passwd_secret=$(kubectl get secret -n $AAP_NS -o=name | grep automation-controller-admin-password)
if [ $? -ne 0 ]; then
    echo "Failed to get AAP admin password secret"
    exit 1
fi

aap_ctrl_admin_passwd=$(kubectl get  -n $AAP_NS  "$passwd_secret" -o json | jq -r '.data.password' | base64 -d)
if [ $? -ne 0 ]; then
    echo "Failed to get AAP admin password"
    exit 1
fi

cat << EOF >> prometheus.yaml
- job_name: serviceMonitor/open-cluster-management-addon-observability/aap-metrics
  honor_labels: false
  kubernetes_sd_configs:
  - role: endpoints
    namespaces:
      names:
      - ansible-automation-platform
  scrape_interval: 30s
  metrics_path: /api/v2/metrics
  scheme: http
  basic_auth:
    username: admin
    password: $aap_ctrl_admin_passwd
  relabel_configs:
  - action: keep
    source_labels:
    - __meta_kubernetes_service_label_app_kubernetes_io_component
    regex: automationcontroller
EOF

# update the prometheus config with AAP job conf
kubectl delete cm -n $OBS_NS prometheus-k8s-config
kubectl create cm -n $OBS_NS prometheus-k8s-config --from-file prometheus.yaml
if [ $? -ne 0 ]; then
    echo "Failed to update prometheus-k8s-config configmap"
    exit 1
fi

kubectl label cm -n $OBS_NS prometheus-k8s-config app-configured=true
