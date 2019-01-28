#!/bin/bash

# Install tenks, and use it to create two virtual bare metal nodes.

set -e

if [[ ! -d tenks ]]; then
  git clone https://github.com/openstack/tenks
  pushd tenks
  # Checkout https://review.openstack.org/#/c/633263/ to support specifying
  # images via URL.
  git fetch https://git.openstack.org/openstack/tenks refs/changes/63/633263/1 && git checkout FETCH_HEAD
  popd
fi
virtualenv tenks-venv
source tenks-venv/bin/activate
pip install -U pip
pip install -U setuptools
pip install ./tenks

ansible-galaxy install \
  --role-file="tenks/requirements.yml" \
  --roles-path="tenks/ansible/roles/"

ansible-playbook \
  -vvv \
  --inventory "tenks/ansible/inventory" \
  --extra-vars=@"tenks-deploy-config.yml" \
  "tenks/ansible/deploy.yml"
