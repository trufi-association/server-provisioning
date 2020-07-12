# Trufi Server Provisioning

## OTP Graphs

Create a folder for each graph you want to serve in `files/graphs/` and place
`build-config.json`, `router-config.json`, GTFS file(s) and the PBF extract for
the area you provide routing for into it.

Graphs will be built during provisioning when they don't exist yet.

Have a look at https://docs.opentripplanner.org/en/latest/Basic-Tutorial/ for
more information.

## Tiles

Depending on what should be served to the client, place `*.mbtiles` files into
`files/tiles/`. Get them from https://openmaptiles.com/downloads/planet/.

| Dataset       | When to use                     |
| ------------- | ------------------------------- |
| OpenStreetMap | Required for all map types      |
| Contour lines | Required for terrain map type   |
| Hillshade     | Required for terrain map type   |
| Satellite     | Required for satellite map type |

## Ansible

Create an `inventory.yml` based on `inventory.yml.dist` defining the target
machines. Run `ansible all -m ping -i inventory.yml` to make sure they are
reachable.

### Parameters

| Name                       | Description                                                                                                  |
| -------------------------- | ------------------------------------------------------------------------------------------------------------ |
| ansible_user               | The user to run commands under. Typically `root`                                                             |
| ansible_python_interpreter | Path to python binary. Typically `/usr/bin/python3`                                                          |
| docker_username            | Username to pull docker images. As this will pull images from GitHub, this needs to be your GibHub username. |
| docker_password            | GitHub personal access token with `read:packages` scope.                                                     |
| install_dir                | Where to install trufi server. Typically `/srv/trufi`                                                        |
| hostname                   | The hostname the server will run on. Required to get a certificate.                                          |
| email                      | Contact email, mainly for Let's Encrypt                                                                      |
| build_graphs               | Whether you want to build graphs as part of the deployment. yes by default.                                  |

Make sure to also fill in the ip or hostname to the target server.

### Install

Provision the server with `ansible-playbook -i inventory.yml playbook.yml`. This
will install docker, copy over files, build graphs and start the services.

Run again to apply latest changes. Everything that is up to date will be left intact.
