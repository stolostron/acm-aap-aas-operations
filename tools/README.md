# tools

## [metric simulator](./metric-simulator)

Metric simulator is used to generate the Prometheus metrics, then we can create some fake metrics to trigger alerts to ensure the whole monitoring solution is work well.

### [metric conf](./metric-simulator/metric-config.yaml)

There is an example for metrics configuration:

```
metrics:
  - name: kube_pod_container_status_restarts_total
    help: number of container restarts per container
    type: counter
    label_keys: [cluster, namespace, pod, container]
    sequences:
      - label_values: [c1, n1, p1, c1]
        interval: 10
        value: 0
      - label_values: [c2, n2, p2, c2]
        interval: 30
        value: 0
  - name: kube_pod_status_phase
    help: pod status phase
    type: gauge
    label_keys: [cluster, namespace, pod, container]
    sequences:
      - label_values: [c1, n1, p1, c1]
        interval: 10
        value: 1
      - label_values: [c2, n2, p2, c2]
        interval: 20
        value: 1
```

Use this metric configuration, metric simulator should generate the following metrics:

```
# HELP kube_pod_container_status_restarts_total number of container restarts per container
# TYPE kube_pod_container_status_restarts_total counter
kube_pod_container_status_restarts_total{cluster="c1",container="c1",namespace="n1",pod="p1"} 2
kube_pod_container_status_restarts_total{cluster="c2",container="c2",namespace="n2",pod="p2"} 1
# HELP kube_pod_status_phase pod status phase
# TYPE kube_pod_status_phase gauge
kube_pod_status_phase{cluster="c1",container="c1",namespace="n1",pod="p1"} 1
kube_pod_status_phase{cluster="c2",container="c2",namespace="n2",pod="p2"} 1
```

### Supported keywords

keyword | description
---  | ------
name | metric name
help | metric help
type | metric type
label_keys | metric label keys
sequences.label_values | metric label values
sequences.interval | number of seconds between each operation will be performed
sequences.value | metric value
sequences.min_value | mininum value of metric, it only will be used with the `gauge` metric type
sequences.max_value | maximum value of metric, it only will be used with the `gauge` metric type
sequences.operation | the operation that will be applied, it only will be used with the `gauge` metric type, choose between `[add, sub, inc, dec]`, if not set this field, then it will set the `value` to metric

### Supported metric types

- Counter
- Gauge
- Histogram (**TODO**)
- Summary (**TODO**)

## [unhealthy-deploy.yaml](./unhealthy-deploy.yaml)

we can use this unhealthy deployment to simulate a unhealthy AAP Pods, and then to trigger the AAP alert.
