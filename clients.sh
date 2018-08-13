#!/bin/bash

set -e

virtualenv os-venv
source os-venv/bin/activate
pip install -U pip
pip install -U setuptools
pip install python-openstackclient python-ironicclient python-ironic-inspector-client

INTERFACE=${INTERFACE:-eth0}
IP=$(ip a show dev $INTERFACE | grep 'inet ' | awk '{ print $2 }' | sed 's/\/.*//g')

mkdir -p ~/.config/openstack
cat << EOF | sudo tee ~/.config/openstack/clouds.yaml
---
clouds:
  bikolla:
    auth_type: "none"
    endpoint: http://$IP:6385
  bikolla-inspector:
    auth_type: "none"
    endpoint: http://$IP:5050
EOF

echo source os-venv/bin/activate to enter the virtual environment
echo export OS_CLOUD=bikolla to use ironic
echo export OS_CLOUD=bikolla to use ironic inspector
