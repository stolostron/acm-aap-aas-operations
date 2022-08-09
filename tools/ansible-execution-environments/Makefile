VIRTUALENV="./venv"
PIP=$(VIRTUALENV)/bin/pip3
ANSIBLE-GALAXY=$(VIRTUALENV)/bin/ansible-galaxy
ANSIBLE-PLAYBOOK=$(VIRTUALENV)/bin/ansible-playbook
ANSIBLE-BUILDER=$(VIRTUALENV)/bin/ansible-builder

# Configuration
VERSION=0.1
TARGET_REGISTRY=quay.io/adecorte

all: venv build-ansible-ee clean-venv

venv:
	LC_ALL=en_US.UTF-8 python3 -m venv $(VIRTUALENV)
	. $(VIRTUALENV)/bin/activate
	$(VIRTUALENV)/bin/python3 -m pip install --upgrade pip
	$(PIP) install ansible==2.10
	$(PIP) install ansible-builder
	$(VIRTUALENV)/bin/ansible-builder --version

build-ansible-ee:
	$(ANSIBLE-BUILDER) create -f ansible_ee_acm/execution-environment.yml
	# Needs Red Hat registry secret to build
	docker login -u="${REGISTRY_USERNAME}" -p='${REGISTRY_PASSWORD}' https://registry.redhat.io
	# Needs target registry (quay.io in this case) to push
	docker login -u="${QUAY_USERNAME}" -p='${QUAY_PASSWORD}' https://quay.io
	docker build -t "${TARGET_REGISTRY}/ansible_ee_acm:${VERSION}" -f context/Containerfile ./context
	docker push "${TARGET_REGISTRY}/ansible_ee_acm:${VERSION}"

clean-venv:
	rm -fr $(VIRTUALENV)
