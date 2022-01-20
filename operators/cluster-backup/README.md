# Enabling `cluster-backup-operator`

This configuration will permit to run `cluster-backup-operator`. It basically goes through 3 actions:
1. Installing `oadp-operator`
2. Installing `cluster-backup-operator` and enabling the `Velero` resource (2.4). Velero uses the S3 bucket as a storage. The S3 bucket storage should be already be available and the bucket name should be added in `kustomization.yaml` file.


## `oadp-operator` installation

Deploy oadp-operator

```shell
oc apply -k operators/cluster-backup
```

## `cluster-backup-operator`

This command will enable `cluster-backup-operator` in  `MCH`.
```shell
oc patch multiclusterhub.operator.open-cluster-management.io  multiclusterhub \
  --type=merge --patch "$(cat operators/cluster-backup/enable-cluster-backup/enableClusterBackup_patch.yaml)" \
  -n open-cluster-management
  ```

To configure the S3 storage and to create the `Velero` resource then run:

```shell
oc apply -k ./operators/cluster-backup/enable-cluster-backup/
```
