FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

RUN microdnf install git jq make iputils tar -y

RUN microdnf update -y && rm -rf /var/cache/yum && microdnf clean all

# install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl && mv kubectl /bin

WORKDIR /tmp

ENV HOME=/tmp

ADD ./aap-metric-checker.sh aap-metric-checker.sh
