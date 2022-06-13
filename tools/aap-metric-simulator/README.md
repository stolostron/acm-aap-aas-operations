## AAP Metric Simulator

## Prerequisites

- You must install ACM 2.5+
- You must enable Observability service
- You must import an AKS cluster to ACM Hub

### deploy simulator on AKS

```
$ kubectl apply -k ./manifests/
namespace/ansible-automation-platform created
clusterrolebinding.rbac.authorization.k8s.io/aap-metric-accessor created
configmap/automation-controller created
secret/automation-controller-admin-password created
service/automation-controller-service created
deployment.apps/automation-controller created
```

### deploy the servicemonitor

```
$ kubectl apply -f manifests/servicemonitor.yaml
servicemonitor.monitoring.coreos.com/aap-metrics created
```

### check the AAP metric

- Check the AAP metrics on the Observability Grafana console:

![](/images/aap-metric-from-simulator.png)

- Use the port-forwad to check the AAP metrics:

```
$ kubectl port-forward -n ansible-automation-platform automation-controller-5ff4c78c9-jtrzd 8080:8080
```
Open this url: http://localhost:8080/api/v2/metrics
