FAKEPATH := "$(PWD):$(PATH)"
K8S_BIN_DIR = ~/bin
KUBECTL_URL = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kubectl"

KUBECTL_CMD := $(shell PATH=$(FAKEPATH) command -v kubectl 2> /dev/null)

ARGOCD_NAMESPACE = argocd

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

.PHONY: install-argocd
install-argocd:
	kubectl apply -k ./cluster-bootstrap/argocd-apps/argocd -n $(ARGOCD_NAMESPACE)

.PHONY: install-acm
install-acm:
	kubectl apply -k ./cluster-bootstrap/argocd-apps/acm -n $(ARGOCD_NAMESPACE)

.PHONY: install-observability
install-observability:
	kubectl apply -k ./cluster-bootstrap/argocd-apps/multicluster-observability -n $(ARGOCD_NAMESPACE)

.PHONY: prometheus-config
prometheus-config:
	kubectl apply -k ./cluster-bootstrap/argocd-apps/prometheus-config -n $(ARGOCD_NAMESPACE)

.PHONY: install-grafana-dev
install-grafana-dev:
	kubectl apply -k ./cluster-bootstrap/argocd-apps/grafana-dev -n $(ARGOCD_NAMESPACE)	
