# How to use the pipelines

Currently we setup a Grafana develop instance in our NA and EMEA production envs. Here is the general steps of how to use the Grafana dev instance together with Openshift pipelines/GitOps to automate the process of customize the Grafana dashboard.

1. Login to the Grafana dev instance. It will create a user with your Github ID.
   * Prod NA: https://multicloud-console.apps.acm5.na.mgmt.ansiblecloud.com/grafana-dev/
   * Prod EMEA: https://multicloud-console.apps.acm10.na.mgmt.ansiblecloud.com/grafana-dev/

2. Open OCP console and run the pipeline `switch-to-grafana-admin` with your Github ID as the param `userName`'s value. 

3. Refresh the grafana console, then you can find the **+** icon and follow these steps to design your dashboard:
   * Click the + icon on the left panel, select **Create Dashboard**, and then click **Add new panel**.
   * In the New Dashboard/Edit Panel view, go to the **Query** tab.
   * Configure your query by selecting **Observatorium** from the data source selector and enter a PromQL query.
   * Click the **Save** icon in the top right corner of your screen to save the dashboard.
   * Add a descriptive name, and then click **Save**.

4. Nav back to OCP console and run the pipeline `export-dashboard` with the dashboard name you just saved. The output of this pipeline will be a PR named `add-new-dashboard-$dashboard_name`. Lastly nav to https://github.com/stolostron/acm-aap-aas-operations/pulls to review and merge the PR. Then Argocd will handle leftover job to deploy your dashboard to ACM grafana dashboard.
