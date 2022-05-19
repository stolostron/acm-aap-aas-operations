FROM registry.access.redhat.com/ubi8-minimal:latest

RUN microdnf update -y && rm -rf /var/cache/yum && microdnf clean all

RUN microdnf install git jq make iputils tar -y

# install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl && mv kubectl /bin

# install oc
RUN mkdir oc-tmp && cd oc-tmp \
    && curl -LO https://github.com/openshift/okd/releases/download/4.10.0-0.okd-2022-03-07-131213/openshift-client-linux-4.10.0-0.okd-2022-03-07-131213.tar.gz \
    && tar -xvf openshift-client-linux-4.10.0-0.okd-2022-03-07-131213.tar.gz \
    && chmod a+x oc && mv oc /bin && rm -rf ../oc-tmp

ENTRYPOINT ["/bin/bash"]
