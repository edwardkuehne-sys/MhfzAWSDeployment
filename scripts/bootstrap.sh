#!/bin/bash -xe
#TODO add mhfz service to bootstrap
exec > >(tee -a /var/log/mhfz-bootstrap.log | logger -t mhfz-bootstrap -s 2>/dev/console) 2>&1

echo "=== Bootstrap started ==="
date
apt-get update
apt-get install -y ca-certificates curl awscli 7zip yq

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg \
  -o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian trixie stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update

echo "=== Installing docker ==="
apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

systemctl enable --now docker

usermod -aG docker admin

echo "=== Creating MHFZ directories ==="
mkdir -p /home/admin/mhfz
chown -R admin:admin /home/admin/mhfz

echo "=== Installing MHFZ systemd service ==="
cp /opt/mhfz-deployment/scripts/erupe.service /etc/systemd/system/erupe.service

systemctl daemon-reload
systemctl enable erupe.service

chmod +x /opt/mhfz-deployment/scripts/*.sh

echo "=== Starting deployment ==="
sudo -u admin sg docker -c \
  '/opt/mhfz-deployment/scripts/deploy.sh'

echo "=== Bootstrap completed successfully ==="
date