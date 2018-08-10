Bikolla
=======

A reimagining of `Bifrost <https://docs.openstack.org/bifrost/latest/>`__ using
`Kolla Ansible <https://docs.openstack.org/kolla-ansible/latest/>`__ to deploy
a containerised control plane for standalone bare metal environments.

Prerequisites
-------------

A single host. So far only tested on a CentOS 7.5 cloud image.
A user account with passwordless sudo.

Usage
-----

Clone this repo::

    git clone https://github.com/markgoddard/bikolla

Install dependencies, including Ansible, Kolla Ansible and Docker::

    cd bikolla
    ./install.sh

This will likely log you out. You should log back in, picking up membership of
the ``docker`` group.

Next, deploy containers::

    cd bikolla
    ./deploy.sh

You should now have a standalone ironic control plane running in Docker
containers::

    docker ps
