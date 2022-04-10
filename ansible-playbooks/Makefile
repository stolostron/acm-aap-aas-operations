VIRTUALENV="./venv"
PIP=$(VIRTUALENV)/bin/pip3
ANSIBLE-GALAXY=$(VIRTUALENV)/bin/ansible-galaxy
ANSIBLE-PLAYBOOK=$(VIRTUALENV)/bin/ansible-playbook

all: venv 

venv:
	LC_ALL=en_US.UTF-8 python3 -m venv $(VIRTUALENV)
	. $(VIRTUALENV)/bin/activate
	$(PIP) install ansible==2.10
	$(PIP) install kubernetes
	$(ANSIBLE-GALAXY) collection install kubernetes.core
	$(VIRTUALENV)/bin/python3 -m pip install --upgrade pip

clean-venv:
	rm -fr $(VIRTUALENV)
