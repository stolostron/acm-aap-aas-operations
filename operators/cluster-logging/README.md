Use this kustomzation to deploy openshift-logging on openshift clusters

We can define specific operator channels and startingCSV versions with manual installplans.
However, to apply a manual install plan, we will always have to manually approve the installplan.

```bash
oc patch installplan $(oc get ip -n openshift-logging -o=jsonpath='{.items[?(@.spec.approved==false)].metadata.name}') -n openshift-logging --type merge --patch '{"spec":{"approved":true}}'
```

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