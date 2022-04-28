# Prometheus configuration policy

This application will deploy the policy to configure the Alertmanager for AAP monitoring automatically. Token and secrets listed as follow are all stored in Vault currently. 

- If your Kubernetes version is before v1.21, please update the `CronJob` version to `v1beta1`

## [aap-alertmgr-conf-policy.yaml](./overlay/dev/aap-alertmgr-conf-policy.yaml)

configure the following parameters:

- `<SLACK_API_URL>`: Your global slack api url, you can overwrite it via set the `slack_configs[].api_url`, for example, set the `<AOC_SLACK_API_URL>` to overwrite the global setting

- `<ACM_CONSOLE_URL>`: Your ACM console url

- `<ALERTMANAGER_URL>`: Your alertmanager url

- `<SERVICE_KEY>`: Your pagerduty service key

If your ACM Hub cluster is private and enabled the cluster scope proxy, the following HTTP proxy to the `slack_configs` will be configed. To check your proxy:

```
$ kubectl get proxy -o yaml | grep httpProxy
    httpProxy: http://your.proxy.url:3128
```
Then configure the HTTP proxy to the `slack_configs` section:

```
...

receivers:
  - name: default-receiver
    slack_configs:
    - channel: team-acm-sre-stage-alerts
      http_config:
        proxy_url: http://your.proxy.url:3128
...
```
