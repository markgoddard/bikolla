#!/bin/bash

set -e

sudo yum install wget python-devel libffi-devel gcc openssl-devel libselinux-python python-virtualenv
if [[ ! -f ~/.ssh/id_rsa ]]; then
  ssh-keygen  -f ~/.ssh/id_rsa -t rsa -N ''
fi
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys 
virtualenv kolla-venv
ln -s /usr/lib64/python2.7/site-packages/selinux/ kolla-venv/lib/python2.7/site-packages/
source kolla-venv/bin/activate
pip install -U pip
pip install -U setuptools
pip install 'kolla-ansible==7.0.0.0b3'
pip install ansible
sudo mkdir -p /etc/kolla
sudo chown $USER: -R /etc/kolla/
cp -r etc/kolla/* /etc/kolla/
cp kolla-venv/share/kolla-ansible/etc_examples/kolla/passwords.yml /etc/kolla/
wget -O /etc/kolla/config/ironic/ironic-agent.initramfs https://tarballs.openstack.org/ironic-python-agent/tinyipa/files/tinyipa-stable-queens.gz
wget -O /etc/kolla/config/ironic/ironic-agent.kernel https://tarballs.openstack.org/ironic-python-agent/tinyipa/files/tinyipa-stable-queens.vmlinuz
kolla-genpwd
kolla-ansible -i /etc/kolla/inventory/all-in-one bootstrap-servers
# TODO: Use kolla_user in Rocky.
sudo chown -R centos: kolla-venv/
sudo usermod -aG docker centos
if ! groups | grep docker >/dev/null; then
  echo "Logging out to apply docker group membership"
  echo "Log in again and run deploy.sh"
  logout
else
  echo "Now run deploy.sh"
fi
