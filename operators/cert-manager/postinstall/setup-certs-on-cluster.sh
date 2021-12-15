#!/bin/bash

oc patch ingresscontroller.operator default \
     --type=merge -p \
     '{"spec":{"defaultCertificate": {"name": "apps-domain-tls"}}}' \
     -n openshift-ingress-operator
