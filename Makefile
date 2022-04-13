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

.PHONY: deploy-dev
deploy-dev:
	sh ./scripts/install.sh dev

.PHONY: deploy-stage
deploy-stage:
	sh ./scripts/install.sh stage

.PHONY: deploy-alert-manager-dev
deploy-alert-manager-dev:
	sh ./scripts/install-alertmanager.sh dev

.PHONY: deploy-alert-manager-dev-private
deploy-alert-manager-dev-private:
	sh ./scripts/install-alertmanager-config-dev.sh dev true

.PHONY: deploy-alert-manager-stage
deploy-alert-manager-stage:
	sh ./scripts/install-alertmanager.sh stage true
