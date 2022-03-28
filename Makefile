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

.PHONY: install-argocd
install-argocd:
	kubectl apply -k ./cluster-bootstrap/argocd-apps/argocd -n argocd

.PHONY: install-acm
install-acm:
	kubectl apply -k ./cluster-bootstrap/argocd-apps/acm -n argocd

.PHONY: install-observability
install-obs:
	kubectl apply -k ./cluster-bootstrap/argocd-apps/multicluster-observability -n argocd

.PHONY: prometheus-config
install-obs:
	kubectl apply -k ./cluster-bootstrap/argocd-apps/prometheus-config -n argocd