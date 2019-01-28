#!/bin/bash

set -e

virtualenv os-venv
source os-venv/bin/activate
pip install -U pip
pip install -U setuptools
pip install python-openstackclient python-ironicclient python-ironic-inspector-client

INTERFACE=${INTERFACE:-breth1}
IP=$(ip a show dev $INTERFACE | grep 'inet ' | awk '{ print $2 }' | sed 's/\/.*//g')

if [[ ! -f ~/.config/openstack/clouds.yaml ]]; then
    mkdir -p ~/.config/openstack
    cat << EOF | sudo tee ~/.config/openstack/clouds.yaml
---
clouds:
  bifrost:
    auth_type: "none"
    endpoint: http://$IP:6385
  bifrost-inspector:
    auth_type: "none"
    endpoint: http://$IP:5050
EOF
fi

echo source os-venv/bin/activate to enter the virtual environment
echo export OS_CLOUD=bifrost to use ironic
echo export OS_CLOUD=bifrost-inspector to use ironic inspector
