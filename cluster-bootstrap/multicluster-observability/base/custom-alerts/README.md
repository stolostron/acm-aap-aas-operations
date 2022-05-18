# Custom rules

This application will deploy the custom rules for AAP monitoring after you have enabled the observability service by creating a MultiClusterObservability CustomResource (CR) instance. For more information, see [Creating custom rules](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.4/html/observability/observing-environments-intro#creating-custom-rules).

## Alerts

Now we provide the following alerts for AAP monitoring:

Alert | Description
---  | ------
AAPDeploymentReplicasMismatch | AAP Deployment in `ansible-automation-platform` namespace actual number of replicas is inconsistent with the set number of replicas over 5 minutes
AAPPodContainerTerminated | AAP Pod in `ansible-automation-platform` namespace has been in terminated state for longer than 10 minutes
AAPPodFrequentlyRestarting | AAP Pod in `ansible-automation-platform` namespace is restarting many times over 2 minutes
AAPPodNotReady | AAP Pod in `ansible-automation-platform` namespace has been in a non-ready state for longer than 15 minutes
AAPPodRestartingTooMuch | AAP Pod in `ansible-automation-platform` namespace restart more than 10 times over 10 minutes
AAPStatefulSetReplicasMismatch | AAP StatefulSet in `ansible-automation-platform` namespace actual number of replicas is inconsistent with the set number of replicas over 5 minutes
MetricsCollectorMissing | Metrics collector Pod missing on some managed clusters for longer than 5 minutes
PolicyNotCompliant | Policy is not compliant for longer than 5 minutes

## Adding an alert

If you want to add an alert based on collected metrics. Please following [this guide](https://github.com/stolostron/sre-doc/blob/main/guides/how-to-define-alert.md) to define a new alert and make sure you have the required fields for alert.

You can find some useful alerts from this page: [Awesome Prometheus alerts](https://awesome-prometheus-alerts.grep.to/rules.html)
