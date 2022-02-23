# Copyright Contributors to the Open Cluster Management project
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

WORKDIR /tmp

ENV HOME=/tmp

RUN curl -LO https://dl.k8s.io/release/v1.23.0/bin/linux/amd64/kubectl \
    && chmod +x kubectl && mv ./kubectl /usr/local/bin/kubectl \
    && curl -LO https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 \
    && chmod +x jq-linux64 && mv ./jq-linux64 /usr/local/bin/jq

ADD ./configure-aks-prom.sh configure-aks-prom.sh
