# Custom Rules

This application will deploy the custom rules for AAP monitoring after you have enabled the observability service by creating a MultiClusterObservability CustomResource (CR) instance. For more information, see [Creating custom rules](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.4/html/observability/observing-environments-intro#creating-custom-rules).

Now we provide the following alerts for AAP monitoring:

Alert | Description
---  | ------
AutomationControllerResponseError | AAP controller in `ansible-automation-platform` namespace response error (status="500") is more than 3 over 1 minutes. To enable this alert, we should install vector to AAP AKS cluster to collect AAP controller log events and push to ACM Hub. For more information, please refer to [this doc](https://github.com/songleo/acm-aap-aas-operations/tree/add-alerts-metrics/operators/vector#readme)
AAPPodRestartingTooMuch | AAP Pod in `ansible-automation-platform` namespace restart more than 10 times over 10 minutes
AAPPodFrequentlyRestarting | AAP Pod in `ansible-automation-platform` namespace is restarting {{ printf "%.2f" $value }} times over 2 minutes
AAPPodContainerTerminated | AAP Pod in `ansible-automation-platform` namespace has been in terminated state for longer than 10 minutes
AAPPodNotReady | AAP Pod in `ansible-automation-platform` namespace has been in a non-ready state for longer than 15 minutes
AAPDeploymentReplicasMismatch | AAP Deployment in `ansible-automation-platform` namespace actual number of replicas is inconsistent with the set number of replicas over 5 minutes
AAPStatefulSetReplicasMismatch | AAP StatefulSet in `ansible-automation-platform` namespace actual number of replicas is inconsistent with the set number of replicas over 5 minutes
