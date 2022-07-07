VIRTUALENV="./venv"
PIP=$(VIRTUALENV)/bin/pip3
ANSIBLE-GALAXY=$(VIRTUALENV)/bin/ansible-galaxy
ANSIBLE-PLAYBOOK=$(VIRTUALENV)/bin/ansible-playbook

all: venv

venv: venv-generic venv-git

venv-generic:
	LC_ALL=en_US.UTF-8 python3 -m venv $(VIRTUALENV)
	. $(VIRTUALENV)/bin/activate
	$(VIRTUALENV)/bin/python3 -m pip install --upgrade pip
	$(PIP) install ansible==2.10
	$(PIP) install ansible-lint
	$(PIP) install -r requirements-azure.txt
	$(ANSIBLE-GALAXY) collection install azure.azcollection
	$(PIP) install kubernetes
	$(PIP) install selinux
	$(ANSIBLE-GALAXY) collection install kubernetes.core
	$(ANSIBLE-GALAXY) collection install ansible.posix

venv-git:
	${PIP} install pre-commit
	${PIP} install detect-secrets

clean-venv:
	rm -fr $(VIRTUALENV)
