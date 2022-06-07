## AAP Metric Simulator

## Prerequisites

- You must install ACM
- You must enable Observability service
- You must import an AKS cluster to ACM Hub

### deploy simulator on AKS

```
$ kubectl apply -k ./manifests/
namespace/ansible-automation-platform created
clusterrolebinding.rbac.authorization.k8s.io/aap-metric-accessor created
configmap/aap-metric-simulator created
service/aap-metric-simulator created
deployment.apps/aap-metric-simulator created
```

### add job to prometheus conf

```
- job_name: serviceMonitor/open-cluster-management-addon-observability/aap-metrics
  honor_labels: false
  kubernetes_sd_configs:
  - role: endpoints
    namespaces:
      names:
      - ansible-automation-platform
  scrape_interval: 30s
  metrics_path: /metrics
  scheme: http
```

### check the AAP metric

![](/images/aap-metric-from-simulator.png)
