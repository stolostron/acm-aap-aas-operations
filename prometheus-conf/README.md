# Prometheus configuration policy

This application will deploy the policy to configure the Prometheus and Alertmanager for AAP monitoring automatically.

## [aap-prom-conf-policy.yaml](./aap-prom-conf-policy.yaml)

- `clusterSelector`: configure the `clusterSelector` to select your AAP managedclusters
  ```
    clusterSelector:
    matchExpressions:
        - key: name
        operator: In
        values:
            - AKS
  ```

- If your Kubernetes version is before v1.21, please update the `CronJob` version to `v1beta1`

## [aap-alertmgr-conf-policy.yaml](./aap-alertmgr-conf-policy.yaml)

configure the following parameters:

- `_SLACK_API_URL_`: Your slack api url

- `_ACM_CONSOLE_URL_`: Your ACM console url, run this command to get it:
  ```
    $ kubectl get route -n open-cluster-management multicloud-console -o jsonpath="{.spec.host}"
    multicloud-console.apps.demo-aws-495-vzzmc.demo.red-chesterfield.com
  ```

- `_ALERTMANAGER_URL_`: Your alertmanager url, run this command to get it:
  ```
    $ kubectl get route -n open-cluster-management-observability alertmanager -o jsonpath="{.spec.host}"
    alertmanager-open-cluster-management-observability.apps.demo-aws-495-vzzmc.demo.red-chesterfield.com
  ```

- `_SERVICE_KEY_`: Your pagerduty service key
