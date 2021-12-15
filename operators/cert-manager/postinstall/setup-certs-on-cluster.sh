#!/bin/bash

oc patch ingresscontroller.operator default \
     --type=merge -p \
     '{"spec":{"defaultCertificate": {"name": "apps-domain-tls-cert"}}}' \
     -n openshift-ingress-operator

oc patch proxy/cluster --type=merge --patch='{"spec":{"trustedCA":{"name":"api-domain-tls"}}}'
