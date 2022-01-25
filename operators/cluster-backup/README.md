# Enabling `cluster-backup-operator`

This configuration will permit to run `cluster-backup-operator`. It basically goes through 3 actions:
1. Installing `oadp-operator`
2. Installing `cluster-backup-operator`
3. Storage configuration and `Velero` resource creation. .


## Instaling `oadp-operator`

To deploy oadp-operator

```shell
oc apply -k operators/cluster-backup
```

## Installing `cluster-backup-operator`

This command will enable `cluster-backup-operator` in  `MCH`.
```shell
oc patch multiclusterhub.operator.open-cluster-management.io  multiclusterhub \
  --type=merge --patch "$(cat operators/cluster-backup/enable-cluster-backup/enableClusterBackup_patch.yaml)" \
  -n open-cluster-management
  ```

## Storage configuration and `Velero` resource creation

Creating `Velero` resource will trigger `oadp-operator` to create a `Velero` POD. Velero saves the resources on a storage. The storage must be provisioned and configured in the Velero resource. For `AWS` the storage has to be an S3 storage. For `Azure` the storage is an `Azure Storage`. To access the storage the propoer`credentials` should be supplied as a `secret` (referenced in the `Velero` resource).All this is enabled through one single command which varies according to the the different cloud provider, See [docs](https://github.com/openshift/oadp-operator/blob/master/docs/config/azure_plugin.md)


Hence to install on `AWS` one should run

```shell
oc apply -k ./operators/cluster-backup/enable-cluster-backup/overlays/aws
```

for `Azure`

```shell
oc apply -k ./operators/cluster-backup/enable-cluster-backup/overlays/azure
```



## Schedule backups

To schedule a cluster backup

```shell
cat <<'EOF' | kubectl create -f -
apiVersion: cluster.open-cluster-management.io/v1beta1
kind: BackupSchedule
metadata:
  name: backup-schedule-acm
  namespace: openshift-adp
spec:
  maxBackups: 10
  veleroSchedule: 0 */8 * * *
  veleroTtl: 72h
EOF
```

To verify backup created

```shell
$ oc get backups.velero.io -n openshift-adp
NAMESPACE       NAME                                           AGE
openshift-adp   acm-credentials-schedule-20220125181109        54m
openshift-adp   acm-managed-clusters-schedule-20220125181109   54m
openshift-adp   acm-resources-schedule-20220125181109          54m
```


### Restoring


In case you want to restore a backup you can do:

```shell
cat << 'EOF' | oc create -f -
apiVersion: cluster.open-cluster-management.io/v1beta1
kind: Restore
metadata:
  name: restore-acm
  namespace: openshift-adp
spec:
  veleroManagedClustersBackupName: latest
  veleroCredentialsBackupName: latest
  veleroResourcesBackupName: latest
EOF
```
