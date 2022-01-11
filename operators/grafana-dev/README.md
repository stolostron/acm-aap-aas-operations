# Grafana Dev

This application will deploy the Grafana developer instance after you have enabled the observability service by creating a MultiClusterObservability CustomResource (CR) instance, then you can design your Grafana dashboard via grafana-dev instance. For more information, see [Designing your Grafana dashboard](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.4/html/observability/observing-environments-intro#designing-your-grafana-dashboard).

## Pre-install

- Edit [kustomization.yaml](./grafana-dev/kustomization.yaml) to ensure use the same image as the observability service grafana instance

- Edit [resource-patch.yaml](./grafana-dev/resource-patch.yaml) to ensure use a reasonable resource request

- Edit [pvc-patch.yaml](./grafana-dev/pvc-patch.yaml) to ensure use the valid storage class name and reasonable storage size

## Deploying this Application

To deploy this application, simply `oc apply -k ./grafana-dev` from the root of this project, and switch the user role to Grafana administrator with the [switch-to-grafana-admin.sh](https://github.com/stolostron/multicluster-observability-operator/blob/release-2.4/tools/switch-to-grafana-admin.sh) script.

- Select the Grafana URL [https://$ACM_URL/grafana-dev/](https://$ACM_URL/grafana-dev/) and log in.
- Then run the following command to add the switched user as Grafana administrator. For example, after you log in using kubeadmin, run following command:

    ```shell
    ./switch-to-grafana-admin.sh kube:admin
    User <kube:admin> switched to be grafana admin
    ```

The Grafana developer instance is set up.
