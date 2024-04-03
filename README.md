# Charmed Trino ROCK

This repository contains the packaging metadata for creating a Charmed Trino ROCK. This ROCK image is based on the upstream [Trino](https://repo.maven.apache.org/maven2/io/trino/trino-server) image.

For more information on ROCKs, visit the [rockcraft Github](https://github.com/canonical/rockcraft).

## Building the ROCK
The steps outlined below are based on the assumption that you are building the ROCK with the latest LTS of Ubuntu.
If you are using another version of Ubuntu or another operating system, the process may be different. 
To avoid any issue with other operating systems you can simply build the image with [multipass](https://multipass.run/):
```bash
sudo snap install multipass
multipass launch -n rock-dev -m 8g -c 2 -d 20G
multipass shell rock-dev
```
### Clone Repository
```bash
git clone https://github.com/canonical/charmed-trino-rock.git
cd charmed-trino-rock
```
### Installing & Configuring Prerequisites
```bash
sudo snap install rockcraft --edge --classic
sudo snap install skopeo --edge --devmode
sudo lxd init --auto

# Note: Docker must be installed after LXD is initialized due to firewall rules incompatibility.
sudo snap install docker
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Note: disabling and enabling docker snap is required to avoid sudo requirement. 
# As described in https://github.com/docker-snap/docker-snap.
sudo snap disable docker
sudo snap enable docker
```
### Packing and Running the ROCK
```bash
rockcraft pack
sudo skopeo --insecure-policy copy oci-archive:charmed-trino-rock_418-22.04-edge_amd64.rock docker-daemon:charmed-trino-rock:418
docker run -d --name trino-coordinator -p 8080:8080 charmed-trino-rock:418 start trino-server
```
### Login
To access Trino UI, now exit the multipass instance run `multipass list` for the below output.
```
Name                    State             IPv4             Image
rock-dev                Running           10.137.215.60    Ubuntu 22.04 LTS
                                          10.194.234.1
                                          172.17.0.1
```
Navigate to `<VM IP Address>:8080` (in this case 10.137.215.60:8080) and login with `admin`.
Further information on connecting data sources can be found at [trino.io](https://trino.io/docs/current/).

## Using Makefile

`make dev` will create the multipass image, clone the repo, install and configure the prerequisites.
`make build` will pack the rock for you
`make install` will build the oci image and run it
`make clean` will remove build artifacts and enable you to rebuild
`make clean-all` will remove the image and get you ready to start from `make dev`

## License
The Charmed Trino ROCK is free software, distributed under the Apache
Software License, version 2.0. See
[LICENSE](https://github.com/canonical/charmed-trino-rock/blob/main/LICENSE)
for more information.