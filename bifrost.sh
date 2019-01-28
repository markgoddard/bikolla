#!/bin/bash

# Install bifrost, use it to build a CentOS image and deploy all nodes.

set -e

# Required for building configdrives.
sudo yum -y install genisoimage

if [[ ! -d bifrost ]]; then
  git clone https://github.com/openstack/bifrost
  pushd bifrost
  # Checkout https://review.openstack.org/#/c/633476/, which includes two minor
  # fixes.
  git fetch https://git.openstack.org/openstack/bifrost refs/changes/76/633476/1 && git checkout FETCH_HEAD
  popd
fi

virtualenv bifrost-venv
if [[ ! -L bifrost-venv/lib/python2.7/site-packages/selinux ]]; then
  ln -s /usr/lib64/python2.7/site-packages/selinux/ bifrost-venv/lib/python2.7/site-packages/
fi
source bifrost-venv/bin/activate
pip install -U pip
pip install -U setuptools
pip install ./bifrost
pip install ansible
# Required to build images.
pip install diskimage-builder
# Required by bifrost_inventory.py
pip install shade

cd bifrost/playbooks
export VENV=$VIRTUAL_ENV
ansible-playbook -i inventory/target -e @../../bifrost.yml install.yaml
sudo rsync /httpboot/deployment_image.qcow2 /var/lib/docker/volumes/ironic_ipxe/_data/
# bifrost_inventory.py doesn't understand clouds.yaml.
source ~/openrc
export BIFROST_INVENTORY_SOURCE=ironic
ansible-playbook -i inventory/bifrost_inventory.py -e @../../bifrost.yml deploy-dynamic.yaml
