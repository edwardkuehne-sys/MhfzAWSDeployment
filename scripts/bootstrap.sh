#!/bin/bash -xe

apt-get update
apt-get install -y docker.io awscli 7zip curl

systemctl enable --now docker

curl -fL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
    -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

usermod -aG docker admin

mkdir -p /home/admin/mhfz
chown -R admin:admin /home/admin/mhfz

chmod +x /opt/mhfz-deployment/scripts/*.sh

sudo -u admin sg docker -c \
  '/opt/mhfz-deployment/scripts/deploy.sh'
