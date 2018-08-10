#!/bin/bash

set -e

docker ps || (echo "Cannot communicate with docker engine"; exit 1)
source kolla-venv/bin/activate
kolla-ansible -i /etc/kolla/inventory/all-in-one prechecks -e ansible_python_interpreter=/home/centos/kolla-venv/bin/python
kolla-ansible -i /etc/kolla/inventory/all-in-one pull -e ansible_python_interpreter=/home/centos/kolla-venv/bin/python 
kolla-ansible -i /etc/kolla/inventory/all-in-one deploy -e ansible_python_interpreter=/home/centos/kolla-venv/bin/python 
