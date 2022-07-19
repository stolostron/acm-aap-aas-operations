# ansible-execution-environments

```bash
cd azure_ee_supported_1.13.0
ansible-builder create
cd context
docker build -t quay.io/cdoan_rh/azure_ee_supported:1.13.0 .
```

**Note: Build host environment needs to be a registered RHEL system or build will fail**

## Changelog
### 1.13.0
Based on https://gitlab.cee.redhat.com/aoc/ee-aap-azure-sre/-/tree/main/ with:
1) added collections:
  * awx.awx
  * stolostron.ocm

