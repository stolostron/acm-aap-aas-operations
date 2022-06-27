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

# Deploy stacks(ACM, MultiCluster Observability, Grafana-dev, Prometheus config and custom Alters & Metrics. etc)
.PHONY: deploy-stacks-local
deploy-stacks-local:
	sh ./scripts/install.sh local

.PHONY: deploy-stacks-testing
deploy-stacks-testing:
	sh ./scripts/install.sh testing

# Deploy Alert manager policy
.PHONY: deploy-alert-manager-local
deploy-alert-manager-local:
	sh ./scripts/install-alertmanager.sh local

.PHONY: deploy-alert-manager-testing
deploy-alert-manager-testing:
	sh ./scripts/install-alertmanager.sh testing

# Make entries
.PHONY: deploy-testing
deploy-testing: deploy-stacks-testing deploy-alert-manager-testing

.PHONY: deploy-local
deploy-local: deploy-stacks-local deploy-alert-manager-local
