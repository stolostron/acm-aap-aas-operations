FROM argoproj/argocd:latest
# Switch to root for the ability to perform install
USER root

# Install tools needed for your repo-server to retrieve & decrypt secrets, render manifests
RUN apt-get update && \
    apt-get install -y \
        curl \
        awscli \
        gpg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install the AVP plugin (as root so we can copy to /usr/local/bin)
RUN curl -L -o argocd-vault-plugin https://github.com/IBM/argocd-vault-plugin/releases/download/v0.7.0/argocd-vault-plugin_0.7.0_linux_amd64 \
    chmod +x argocd-vault-plugin \
    mv argocd-vault-plugin /usr/local/bin

# Switch back to non-root user
USER argocd
