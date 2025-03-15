Quadlet for Tryton
==================
The idea is to launch use quadlets and leverage on systemd's funcionality.

Instructions
============
If you want to run these with administrative privileges, you can:

.. code-block:: bash

    # become root
    su -

    # create the necessary secrets
    printf 'S0m3 fuck1n6 P4s5w07d.' | podman secret create tryton-postgres-password -

    # copy all these files to /etc
    cp tryton* /etc/containers/systemd

    # enable tem
    systemctl daemon-reload

    # start the pod
    systemctl start tryton-pod

    # check they're running
    podman ps

    # initialize the DB
    podman run \
        -it \
        --rm \
        --pod=tryton \
        --network=systemd-tryton \
        --env=DB_HOSTNAME=tryton-postgres \
        --secret=tryton-postgres-password,type=env,target=DB_PASSWORD \
        docker.io/tryton/tryton \
            trytond-admin -d tryton --all --email=renich@nortk.com --password

If you want to run it as a regular user:

.. code-block:: bash

    # create the required directory
    mkdir -p ~/.config/containers/systemd

    # create the necessary secrets
    printf 'S0m3 fuck1n6 P4s5w07d.' | podman secret create tryton-postgres-password -

    # copy all these files to /etc
    cp tryton* ~/.config/containers/systemd

    # enable tem
    systemctl --user daemon-reload

    # start the pod
    systemctl --user start tryton-pod

    # check they're running
    podman ps

    # initialize the DB
    podman run \
        -it \
        --rm \
        --pod=tryton \
        --network=systemd-tryton \
        --env=DB_HOSTNAME=tryton-postgres \
        --secret=tryton-postgres-password,type=env,target=DB_PASSWORD \
        docker.io/tryton/tryton \
            trytond-admin -d tryton --all --email=renich@nortk.com --password

