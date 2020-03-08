# Trufi Provisioning

## OTP Graphs

Create a folder for each graph you want to serve in `files/graphs/` and place `build-config.json`, `router-config.json` and GTFS files into it.

## Tiles

Depending on what should be served to the client, place `*.mbtiles` files into `files/tiles/`. Get them from https://openmaptiles.com/downloads/planet/.

Dataset       | When to use
------------- | -------------------------------
OpenStreetMap | Required for all map types
Contour lines | Required for terrain map type
Hillshade     | Required for terrain map type
Satellite     | Required for satellite map type

## Ansible

Create an `inventory.yml` based on `inventory.yml.dist` defining the target machines. Run `ansible all -m ping -i inventory.yml` to make sure they are reachable.

### Parameters

Name | Description
---- | ------------
ansible_user | The user to run commands under. Typically `root`
ansible_python_interpreter | Path to python binary. Typically `/usr/bin/python3`
docker_username | Username to pull docker images. As this will pull images from GitHub, this needs to be your GibHub username.
docker_password | GitHub personal access token with `read:packages` scope.
install_dir | Where to install trufi server. Typically `/srv/trufi`
hostname | The hostname the server will run on. Required to get a certificate.
email | Contact email, mainly for Let's Encrypt
region | Area in format `<country>-<city>`, e.g. `bolivia-cochabamba`, for which a `gtfs-<country>-<city>` npm package exists. Your graphs folder should be named the same.
pbf_url | URL to OSM PBF extract, e.g. from http://download.geofabrik.de/. Get the smallest one containing the region you want to serve.
bbox | Bounding box of the area that wille served in format `LEFT,BOTTOM,RIGHT,TOP`. The defined box will be extracted from the downloaded PBF and stored alongside the graph configs.

Make sure to also fill in the ip or hostname to the target server.

### Install

Provision the server with `ansible-playbook -i inventory.yml playbook.yml`. This will install docker, copy over files and start the services.

Run again to apply latest changes. Everything that is up to date will be left intact.
