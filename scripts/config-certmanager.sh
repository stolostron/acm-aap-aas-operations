#!/bin/bash

while [[ $(oc get sub -n openshift-operators cert-manager -ojsonpath='{.status.currentCSV}' --no-headers --ignore-not-found | wc -l) -eq 0 ]]; 
    do echo "Waiting for cert-manager sub to be created" && sleep 30;
done

_CSV_NAME=$(oc get sub -n openshift-operators cert-manager -ojsonpath='{.status.currentCSV}')

oc patch clusterserviceversion ${_CSV_NAME} \
    --type=json \
    -n openshift-operators \
    --patch='[{"op":"add","path":"/spec/install/spec/deployments/0/spec/template/spec/containers/0/args/-","value":"--dns01-recursive-nameservers-only"},{"op":"add","path":"/spec/install/spec/deployments/0/spec/template/spec/containers/0/args/-","value":"--dns01-recursive-nameservers=8.8.8.8:53,1.1.1.1:53"}]'

printf "=====================Create Cert-manager-config application ...\n"
kubectl apply -k ./cluster-bootstrap/argocd-apps/$1/cert-manager-config
