## Check the AAP metric in the AAP cluster

If you have permission to access the AAP cluster, then run this script to check the AAP metric:

```
$ ./check-the-aap-metrics.sh
```

## Check the AAP metric via ACM policy

If you have no permission to access the AAP cluster, but the AAP cluster has been imported to the ACM, then we can use the policy to check the AAP metric.

- update the `__YOU_AAP_CLUSTER_NAME__` field in `clusterSelector` to select your AAP cluster, for example, to check the AAP cluster `cicd-aap-aas-ansible-d-eastus` metric:

```
...

  clusterSelector:
    matchExpressions:
      - key: name
        operator: In
        values:
          - cicd-aap-aas-ansible-d-eastus
...

```

- create the policy in ACM Hub cluster

```
$ kubectl apply -f aap-metric-checker-policy.yaml
```

- check the AAP metric from ACM console:

![](/images/aap-metrics.png)


## Build & Push Image

```
$ docker build -t quay.io/acm-sre/app-metric-checker -f Dockerfile .
$ docker push quay.io/acm-sre/app-metric-checker:latest
```
