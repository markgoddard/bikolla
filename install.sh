#!/bin/bash

set -e

sudo yum install wget python-devel libffi-devel gcc openssl-devel libselinux-python python-virtualenv

if [[ ! -f ~/.ssh/id_rsa ]]; then
  ssh-keygen  -f ~/.ssh/id_rsa -t rsa -N ''
fi
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys 

if [[ ! -d ./kolla-ansible ]]; then
  git clone https://github.com/openstack/kolla-ansible
fi
virtualenv kolla-venv
if  [[ ! -s kolla-venv/lib/python2.7/site-packages/ ]]; then
  ln -s /usr/lib64/python2.7/site-packages/selinux/ kolla-venv/lib/python2.7/site-packages/
fi
source kolla-venv/bin/activate
pip install -U pip
pip install -U setuptools
pip install ./kolla-ansible
pip install ansible

sudo mkdir -p /etc/kolla
sudo chown $USER: -R /etc/kolla/
cp -r etc/kolla/* /etc/kolla/
mkdir -p /etc/kolla/config/ironic
wget -O /etc/kolla/config/ironic/ironic-agent.initramfs https://tarballs.openstack.org/ironic-python-agent/tinyipa/files/tinyipa-master.gz
wget -O /etc/kolla/config/ironic/ironic-agent.kernel https://tarballs.openstack.org/ironic-python-agent/tinyipa/files/tinyipa-master.vmlinuz

if [[ ! -e /etc/kolla/passwords.yml ]]; then
  cp kolla-venv/share/kolla-ansible/etc_examples/kolla/passwords.yml /etc/kolla/
  kolla-genpwd
fi
kolla-ansible -i /etc/kolla/inventory/all-in-one bootstrap-servers

if ! groups | grep docker >/dev/null; then
  echo "Logging out to apply docker group membership"
  echo "Log in again and run deploy.sh"
  logout
else
  echo "Now run deploy.sh"
fi
