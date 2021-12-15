#!/bin/bash

oc patch clusterserviceversion cert-manager.v1.6.1 \
    --type=json \
    -n openshift-operators \
    --patch='[{"op":"add","path":"/spec/install/spec/deployments/0/spec/template/spec/containers/0/args/-","value":"--dns01-recursive-nameservers-only"},{"op":"add","path":"/spec/install/spec/deployments/0/spec/template/spec/containers/0/args/-","value":"--dns01-recursive-nameservers=8.8.8.8:53,1.1.1.1:53"}]'
