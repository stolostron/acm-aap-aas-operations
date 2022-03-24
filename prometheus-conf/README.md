# Prometheus configuration policy

This application will deploy the policy to configure the Prometheus and Alertmanager for AAP monitoring automatically.

## [aap-prom-conf-policy.yaml](./aap-prom-conf-policy.yaml)

- `clusterSelector`: configure the `clusterSelector` to select your AAP managedclusters
  ```
    clusterSelector:
    matchExpressions:
        - key: vendor
        operator: In
        values:
            - AKS
  ```

- If your Kubernetes version is before v1.21, please update the `CronJob` version to `v1beta1`

## [aap-alertmgr-conf-policy.yaml](./aap-alertmgr-conf-policy.yaml)

configure the following parameters:

- `_SLACK_API_URL_`: Your global slack api url, you can overwrite it via set the `slack_configs[].api_url`, for example, set the `_AOC_SLACK_API_URL_` to overwrite the global setting

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

If your ACM Hub cluster is private and enabled the cluster scope proxy, you need to configure the HTTP proxy to the `slack_configs` section. To check your proxy:

```
$ kubectl get proxy -o yaml | grep httpProxy
    httpProxy: http://your.proxy.url:3128
    httpProxy: http://your.proxy.url:3128
```
Then configure the HTTP proxy to the `slack_configs` section:

```
...

receivers:
  - name: default-receiver
    slack_configs:
    - channel: forum-acm-aap-alerts
      http_config:
        proxy_url: http://your.proxy.url:3128
...
```
