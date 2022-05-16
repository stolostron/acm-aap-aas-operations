FAKEPATH := "$(PWD):$(PATH)"
K8S_BIN_DIR = ~/bin
KUBECTL_URL = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kubectl"

KUBECTL_CMD := $(shell PATH=$(FAKEPATH) command -v kubectl 2> /dev/null)

.PHONY: check-kubectl
check-kubectl:
ifndef KUBECTL_CMD
	$(error "$n$nNo kubectl command in $(FAKEPATH).$n$nPlease run 'make get-cli' to download required binaries.$n$n")
endif

.PHONY: get-kubectl
get-cli:
	@echo "Downloading ${K8S_BIN_DIR}/kubectl for managing k8s resources."
	@curl -sS $(KUBECTL_URL) > ${KUBECTL_BIN}
	@chmod +x ${KUBECTL_BIN}

.PHONY: lint
lint:
	yamllint -d yamllint_conf.yaml .

kind-test:
	@echo "TODO: create Kind test here."

# Deploy stacks(ACM, MultiCluster Observability, Grafana-dev, Prometheus config and custom Alters & Metrics)
.PHONY: deploy-stacks-local
deploy-stacks-local:
	sh ./scripts/install.sh local

.PHONY: deploy-stacks-dev
deploy-stacks-dev:
	sh ./scripts/install.sh dev

.PHONY: deploy-stacks-stage
deploy-stacks-stage:
	sh ./scripts/install.sh stage

# Deploy Alert manager policy
.PHONY: deploy-alert-manager-local
deploy-alert-manager-local:
	sh ./scripts/install-alertmanager.sh local

.PHONY: deploy-alert-manager-dev
deploy-alert-manager-dev:
	sh ./scripts/install-alertmanager.sh dev

.PHONY: deploy-alert-manager-dev-private
deploy-alert-manager-dev-private:
	sh ./scripts/install-alertmanager.sh dev true

deploy-alert-manager-dev-noalerts:
	sh ./scripts/install-alertmanager.sh dev false true

.PHONY: deploy-alert-manager-stage
deploy-alert-manager-stage:
	sh ./scripts/install-alertmanager.sh stage true

# Config cert-manager
.PHONY: config-cert-manager-dev
config-cert-manager-dev:
	sh ./scripts/config-certmanager.sh dev

.PHONY: config-cert-manager-stage
config-cert-manager-stage:
	sh ./scripts/config-certmanager.sh stage

# Make entries
.PHONY: deploy-dev
deploy-dev: deploy-stacks-dev deploy-alert-manager-dev

.PHONY: deploy-dev-private
deploy-dev-private: deploy-stacks-dev deploy-alert-manager-dev-private

.PHONY: deploy-dev-noalerts
deploy-dev-noalerts: deploy-stacks-dev deploy-alert-manager-dev-noalerts

.PHONY: deploy-stage
deploy-stage: deploy-stacks-stage deploy-alert-manager-stage

.PHONY: deploy-local
deploy-local: deploy-stacks-local deploy-alert-manager-local
