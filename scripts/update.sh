#!/bin/bash
set -e

ERUPE_DIR="/home/admin/mhfz/erupe"
CONFIG="/home/admin/mhfz/erupe/docker/config.json"
TEMP_CONFIG="/tmp/mhfz-config.json"

echo "=== Downloading configuration ==="
curl -fL \
  "https://raw.githubusercontent.com/ek-testlab/MhfzAWSDeployment/refs/heads/main/config/config.json" \
  -o "$TEMP_CONFIG"

echo "=== Determining public IPv4 ==="
TOKEN=$(curl -sS --fail \
  -X PUT \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
  http://169.254.169.254/latest/api/token)

PUBLIC_IP=$(curl -sS --fail \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-ipv4)

echo "=== Updating Config ==="
sed -i "s/PUBLIC_IP/$PUBLIC_IP/g" "$TEMP_CONFIG"

cp "$TEMP_CONFIG" "$CONFIG"

rm -f "$TEMP_CONFIG"


echo "=== Restarting Containers ==="
cd "$ERUPE_DIR/docker"

sudo docker compose down
sudo docker compose build
sudo docker compose up -d

rm -f /tmp/mhfz-config.json

echo "=== Deployment complete ==="