#!/bin/bash
set -e

# Download configuration and insert current IP
curl -L "https://raw.githubusercontent.com/ek-testlab/MhfzAWSDeployment/refs/heads/main/config/config.json" \
  -o /tmp/config.json

echo "=== Updating Config ==="
cp /tmp/config.json ~/mhfz/erupe/docker/config.json

echo "=== Restarting Containers ==="
cd ~/mhfz/erupe/docker
sudo docker-compose down
sudo docker-compose build
sudo docker-compose up -d

echo "=== Server Successfully Restarted ==="