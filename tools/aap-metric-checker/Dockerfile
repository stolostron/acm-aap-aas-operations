FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

RUN microdnf update -y && rm -rf /var/cache/yum && microdnf clean all

WORKDIR /tmp

ENV HOME=/tmp

ADD ./aap-metric-checker.sh aap-metric-checker.sh
