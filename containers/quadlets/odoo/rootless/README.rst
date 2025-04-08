=====================
Odoo Rootless Quadlet
=====================


Installation
------------

System Integration
~~~~~~~~~~~~~~~~~~


Create the `odoo` user
----------------------

Create the user for running the **odoo** *quadlets*


  .. code-block:: bash

      root@server ~# useradd -U -m -c 'Containerized odoo service' -d /var/lib/odoo -s /bin/bash odoo

ODOO_UID=$(id -u odoo)
tal vez agregar lingering loginctl enable-linger ${ODOO_UID}

Install `systemd quadlet` files
-------------------------------

- Copy the follwing files to the following directory: `/etc/containers/systemd/`.
  The configuration files should be in the `/etc/odoo/` directory. A the time of this writing the only
  file we're using is the `container.env` file.


  .. code-block:: bash

      root@server ~# mkdir -p /etc/containers/systemd/
      root@server ~# cp odoo.container odoo.network odoo.pod odoo-postgres.container \
                     odoo-postgres.volume odoo.volume /etc/containers/systemd/users/
      root@server ~# mkdir /etc/odoo
      root@server ~# cp ../etc/odoo/container.env /etc/odoo/

  For testing purpouses the `~/.config/containers/systemd` directory can be used but it is not recommended for
  production because the visibility of this user directories is not evident:

  .. code-block:: bash

      root@server ~# mkdir  ~/.config/containers/systemd
      root@server ~# cp odoo.container odoo.network odoo.pod odoo-postgres.container \
                     odoo-postgres.volume odoo.volume  ~/.config/containers/systemd/
      root@server ~# mkdir ~/.config/odoo
      root@server ~# cp ../etc/odoo/container.env .config/containers/systemd/
      root@server ~# sed -i 's/EnvironmentFile=\/etc\/odoo\/container.env/EnvironmentFile=container.env/' \
                     ~/.config/containers/systemd/odoo.container
      root@server ~# sed -i 's/EnvironmentFile=\/etc\/odoo\/container.env/EnvironmentFile=container.env/' \
                     ~/.config/containers/systemd/odoo-postgres.container


- Create the secret:

  To avoid having the  database password in enviroment variables, the secret is available
  inside the containers in the `~/.pgpass` file

  .. code-block:: bash

      # system wide
      root@server ~# printf 'localhost:5432:*:*:S0m3 fuck1n6 P4s5w07d' | sudo -i -u odoo podman secret create odoo-postgres-password -
      # For user
      odoo@server ~$ printf 'localhost:5432:*:*:S0m3 fuck1n6 P4s5w07d' | podman secret create odoo-postgres-password -

- Load and enable the systemd quadlets

  To use **odoo** as system service reload the unit files and start the services.


  .. code-block:: bash

      odoo@server ~$ systemctl daemon-reload
      odoo@server ~$ systemctl enable odoo

  To use **odoo** as user service login as the `odoo` user, reload the unit files and
  start the services.

  .. code-block:: bash

      odoo@server ~$ systemctl --user daemon-reload
      odoo@server ~$ systemctl --user enable odoo


- Start the service

  .. code-block:: bash

      odoo@server ~$ systemctl --user start odoo

  This will start the odoo service as well as the postgresql service.


Troubleshooting
---------------

- To debug the quadlet add the `GlobalArgs=--log-level=debug` to the `[Container]` section in the
  `odoo.container` file.


  .. code-block:: bash

   ...
   [Container]
   GlobalArgs=--log-level=debug
   ...


TODO
----

Add instructions for using a normal Postgres server
