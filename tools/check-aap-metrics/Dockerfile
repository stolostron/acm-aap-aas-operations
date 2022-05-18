FROM quay.io/ocm-observability/tool-cli:latest

RUN microdnf update -y && rm -rf /var/cache/yum && microdnf clean all

WORKDIR /tmp

ENV HOME=/tmp

ADD ./check-the-aap-metrics.sh check-the-aap-metrics.sh
