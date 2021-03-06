Use this kustomzation to deploy openshift-logging on openshift clusters

## Example Forwarding

```yaml
---
apiVersion: "logging.openshift.io/v1"
kind: ClusterLogForwarder
metadata:
  name: instance 
  namespace: openshift-logging 
spec:
  outputs:
  - type: "kafka"
    name: kafka-open
    url: tcp://10.46.55.190:9092/test
  inputs: 
  - name: infra-logs
    infrastructure:
      namespaces:
      - openshift-apiserver
      - openshift-cluster-version
      - openshift-etcd
      - openshift-kube-scheduler
      - openshift-monitoring
  pipelines:
  - name: audit-logs 
    inputRefs:
    - audit
    outputRefs:
    - kafka-open
  - name: infrastructure-logs 
    inputRefs:
    - infrastructure
    outputRefs:
    - kafka-open
```
