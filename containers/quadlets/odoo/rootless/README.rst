=====================
Odoo Rootless Quadlet
=====================

------------
Installation
------------ 

------------------
System Integration
------------------


- Copy the follwing files to the following directory: `/etc/containers/systemd/users/$(UID)` where `UID`
  is the user ID of the user that runs the quadlet.
  The configuration files should be in the `/etc/odoo/` directory. A the time of this writing the only
  file we're using is the `container.env` file.


  .. code-block:: bash

      root@server ~# ODOO_USER_ID=$(id -u imcsk8)
      root@server ~# mkdir /etc/containers/systemd/users/$(ODOO_USER_ID)
      root@server ~# cp odoo.container odoo.network odoo.pod odoo-postgres.container \
                     odoo-postgres.volume odoo.volume /etc/containers/systemd/users/$(ODOO_USER_ID)
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

  .. code-block:: bash

      odoo@server ~$ printf 'S0m3 fuck1n6 P4s5w07d.' | podman secret create odoo-postgres-password -

- Load and enable the systemd quadlets

  .. code-block:: bash

      odoo@server ~$ systemctl --user daemon-reload
      odoo@server ~$ systemctl --user enable odoo


- Start the service

  .. code-block:: bash

      odoo@server ~$ systemctl --user start odoo

  This will start the odoo service as well as the postgresql service.


---------------
Troubleshooting
---------------

- To debug the quadlet add the `GlobalArgs=--log-level=debug` to the `[Container]` section in the
  `odoo.container` file.


  .. code-block:: bash

   ...
   [Container]
   GlobalArgs=--log-level=debug
   ...

====
TODO
====

Add instructions for using a normal Postgres server
