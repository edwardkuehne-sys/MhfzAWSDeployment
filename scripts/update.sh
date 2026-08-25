#!/bin/bash
set -e

ERUPE_DIR="/home/admin/mhfz/erupe"
CONFIG="/home/admin/mhfz/erupe/docker/config.json"

echo "=== Downloading configuration ==="

curl -fL "https://raw.githubusercontent.com/ek-testlab/MhfzAWSDeployment/refs/heads/main/config/config.json" \
  -o /tmp/mhfz-config.json

echo "=== Updating Config ==="

cp /tmp/mhfz-config.json "$CONFIG"

echo "=== Restarting Containers ==="

cd "$ERUPE_DIR/docker"

sudo docker compose down
sudo docker compose build
sudo docker compose up -d

rm -f /tmp/mhfz-config.json

echo "=== Deployment complete ==="