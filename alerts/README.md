# Custom Rules

This application will deploy the custom rules for AAP monitoring after you have enabled the observability service by creating a MultiClusterObservability CustomResource (CR) instance. For more information, see [Creating custom rules](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.4/html/observability/observing-environments-intro#creating-custom-rules).

Now we provide the following alerts for AAP monitoring:

Alert | Description
---  | ------
AutomationControllerResponseError | AAP controller in `ansible-automation-platform` namespace response error. To enable this alert, we should install vector to AAP AKS cluster to collect AAP controller log events and push to ACM Hub. For more information, please refer to [this doc](https://github.com/songleo/acm-aap-aas-operations/tree/add-alerts-metrics/operators/vector#readme)
AAPPodRestartingTooMuch | AAP Pod in `ansible-automation-platform` namespace restarting too much
AAPPodFrequentlyRestarting | AAP Pod in `ansible-automation-platform` namespace frequently restarting
AAPPodContainerTerminated | AAP Pod in `ansible-automation-platform` namespace has been in terminated state
AAPPodNotReady | AAP Pod in `ansible-automation-platform` namespace not ready
AAPDeploymentReplicasMismatch | AAP Deployment in `ansible-automation-platform` namespace does not match the expected number of replicas
AAPStatefulSetReplicasMismatch | AAP StatefulSet in `ansible-automation-platform` namespace does not match the expected number of replicas
