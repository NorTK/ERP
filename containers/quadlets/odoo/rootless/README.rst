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

      root@server ~# mkdir /etc/containers/systemd/users/$(id -u imcsk8)
      root@server ~# cp odoo.container odoo.network odoo.pod odoo-postgres.container odoo-postgres.volume odoo.volume
      root@server ~# mkdir /etc/odoo
      root@server ~# cp ../etc/odoo/container.env /etc/odoo/



- Create the secret:

  .. code-block:: bash

      odoo@server ~$ printf 'S0m3 fuck1n6 P4s5w07d.' | podman secret create tryton-postgres-password -

- Load and enable the systemd quadlets

  .. code-block:: bash

      odoo@server ~$ systemctl --user daemon-reload
      odoo@server ~$ systemctl --user enable odoo


- Start the service

  .. code-block:: bash

      odoo@server ~$ systemctl --user start odoo

  This will start the odoo service as well as the postgresql service.

====
TODO
====

Add instructions for using a normal Postgres server
