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

    ./deploy.sh

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

To install the ``openstack`` client in a virtual environment and create a
``clouds.yaml`` file::

    ./clients.sh
