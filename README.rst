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

Kolla Ansible needs to know the name of the network interface on which
services will be exposed. This should be done as follows::

    export INTERFACE=<interface>

The default is ``breth1``, intended for the development/test use case where
Tenks will be used to provide virtual bare metal machines, which requires a
bridge.  The interface should exist, and have an IP address. A dummy bridge may
be created as follows for testing::

    sudo ip link add breth1 type bridge
    sudo ip link set breth1 up
    sudo ip address add <IP address>/<prefix> dev breth1

Additionally, Kolla Ansible needs to know an IP address range to use for the
dnsmasq DHCP server. This range should be in the same subnet as the IP address
of ``$INTERFACE``. This is done as follows::

    export DHCP_RANGE=<start IP,end IP>

There are various configuration files under ``etc/kolla`` which can be modified
to configure the control plane if necessary.

Install dependencies for Kolla Ansible, including Ansible and Docker::

    cd bikolla
    ./kolla-install.sh

This will likely log you out. You should log back in, picking up membership of
the ``docker`` group.

Next, deploy containers::

    ./kolla-deploy.sh

You should now have a standalone ironic control plane running in Docker
containers::

    docker ps
    CONTAINER ID        IMAGE                                         COMMAND             CREATED             STATUS              PORTS               NAMES
    aa6b3ea09a9b        kolla/centos-binary-dnsmasq:master            "kolla_start"       2 days ago          Up 2 days                               ironic_dnsmasq
    d250bb846777        kolla/centos-binary-ironic-pxe:master         "kolla_start"       2 days ago          Up 2 days                               ironic_ipxe
    5450494242b3        kolla/centos-binary-ironic-pxe:master         "kolla_start"       2 days ago          Up 2 days                               ironic_pxe
    52587635049d        kolla/centos-binary-ironic-inspector:master   "kolla_start"       2 days ago          Up 2 days                               ironic_inspector
    6f6c54cad1ca        kolla/centos-binary-ironic-api:master         "kolla_start"       2 days ago          Up 2 days                               ironic_api
    f0abf333fd25        kolla/centos-binary-ironic-conductor:master   "kolla_start"       2 days ago          Up 2 days                               ironic_conductor
    0d239e6efd92        kolla/centos-binary-rabbitmq:master           "kolla_start"       2 days ago          Up 2 days                               rabbitmq
    5b83db07c6e5        kolla/centos-binary-iscsid:master             "kolla_start"       2 days ago          Up 2 days                               iscsid
    fd56724b0caa        kolla/centos-binary-mariadb:master            "kolla_start"       2 days ago          Up 2 days                               mariadb
    8b693049b9d0        kolla/centos-binary-cron:master               "kolla_start"       2 days ago          Up 2 days                               cron
    31110aa7052d        kolla/centos-binary-kolla-toolbox:master      "kolla_start"       2 days ago          Up 2 days                               kolla_toolbox

At this point there are a few options.

1. Use the ``openstack`` client directly to interact with the ironic and
   inspector APIs
2. Use Tenks to create and register some virtual bare metal nodes for testing
2. Use Bifrost to automate image building and node provisioning

Clients
-------

This method requires a good understanding of ironic and its client.

To install the ``openstack`` client in a virtual environment and create a
``clouds.yaml`` file::

    ./clients.sh

To access ironic::

    export OS_CLOUD=bikolla
    openstack baremetal node list

To access ironic inspector::

    export OS_CLOUD=bikolla-inspector
    openstack baremetal introspection list

Tenks
-----

To install Tenks and use it to create some virtual bare metal nodes::

    ./tenks.sh

The nodes will be registered in ironic. To modify their configuration, edit
``tenks-deploy-config.yml``.

Bifrost
-------

To install Bifrost and use it to create a CentOS image and deploy it to all
nodes::

    ./bifrost.sh

Once this is complete, the deployed nodes should be accessible via SSH. If
using Tenks, check the console logs in ``/var/log/tenks/tk*-console.log`` to
find the assigned IPs.
