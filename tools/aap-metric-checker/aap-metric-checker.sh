#!/bin/bash

AAP_NS="ansible-automation-platform"
kubectl get ns $AAP_NS > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "please make sure the AAP has installed in $AAP_NS namespace, exit."
    exit 1
fi

AAP_METRIC_ENDPOINT=$(kubectl get ep automation-controller-service -n $AAP_NS --no-headers | awk '{print $2}')
AAP_CTRL_ADMIN_PASSWD=$(kubectl get secret automation-controller-admin-password -n $AAP_NS -ojson | jq -r '.data.password' | base64 -d)
AAP_CTRL_POD=$(kubectl get po -n $AAP_NS -l app.kubernetes.io/component=automationcontroller --no-headers | awk '{print $1}')

# to check if AAP are emitting metrics
kubectl exec "$AAP_CTRL_POD" -n $AAP_NS -- curl -u admin:"$AAP_CTRL_ADMIN_PASSWD" http://"$AAP_METRIC_ENDPOINT"/api/v2/metrics/
