# ansible-execution-environments
This folder contains an example of an Ansible Execution Environment built with Github Actions and pushed to Quay.

It contains the stolostron.ocm collection to integrate Ansible and Red Hat Advanced Cluster Management and the Azure collection (which could be replaced with any other similar collection). Full list of included collections can be found in [requirements.yml](ansible_ee_acm/requirements.yml)

## Requirements
* Username/password for redhat.registry.io (see https://access.redhat.com/RegistryAuthentication)
* Username/password for target registry (if authentication is necessary)

## Manual build
```bash
cd tools/ansible-execution-environments
make venv
make build-ansible-ee
```

## How to bump the version
Change the variable in the [Makefile](./Makefile) and launch the manual step above or create a PR
