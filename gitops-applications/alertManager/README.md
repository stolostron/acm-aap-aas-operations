# Configuring AlertManager for Red Hat Advanced Cluster Management

To configure _AlertManager_ for _Red Hat Advanced Cluster Management_ you should only update the `alertmanager-config` secret in the
`open-cluster-management-observability` namespace.  `cp alertmanager.yam.example` to `alertmanager.yaml`, Fill out the URL of the incoming (webhook)[https://api.slack.com/messaging/webhooks] from the slack workspace and channel where `alertManager` will propagatre the alerts.
Running $ oc replace -k .` will replace the `alertmanager.yaml`.
