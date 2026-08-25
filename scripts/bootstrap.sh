#!/bin/bash -xe

apt-get update
apt-get install -y ca-certificates curl awscli 7zip

# Add Docker's official GPG key
install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg \
  -o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
echo \
  "Types: deb
  URIs: https://download.docker.com/linux/debian
  Suites: trixie
  Components: stable
  Architectures: $(dpkg --print-architecture)
  Signed-By: /etc/apt/keyrings/docker.asc" \
  > /etc/apt/sources.list.d/docker.sources

apt-get update

# Install Docker + Buildx + Compose
apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

systemctl enable --now docker

usermod -aG docker admin

mkdir -p /home/admin/mhfz
chown -R admin:admin /home/admin/mhfz

chmod +x /opt/mhfz-deployment/scripts/*.sh

sudo -u admin sg docker -c \
  '/opt/mhfz-deployment/scripts/deploy.sh'