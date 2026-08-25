#!/bin/bash
set -e

echo "=== Deploy started ==="
date

echo "=== Cloning Erupe ==="
git clone https://github.com/Mezeporta/Erupe.git ~/mhfz/erupe

echo "=== Configuring Erupe ==="
# Replace their server image with my own
sed -i '/^[[:space:]]*image: ghcr.io\/mezeporta\/erupe:main$/c\
    image: anononetwothree/mhfz-erupe:latest' ~/mhfz/erupe/docker/docker-compose.yml

echo "=== Setting up Config ==="
TOKEN=$(curl -sS --fail \
  -X PUT \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
  http://169.254.169.254/latest/api/token)

PUBLIC_IP=$(curl -sS --fail \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-ipv4)

echo "Public IPv4: $PUBLIC_IP"
# Inserting the instance's public IPv4 into the config
sed "s/PUBLIC_IP/$PUBLIC_IP/g" \
  /opt/mhfz-deployment/config/config.json \
  > ~/mhfz/erupe/docker/config.json

echo "=== Extracting MHFZ binaries ==="
# Download the permanent game binaries from S3
aws s3 cp s3://my-mhfz-server-data/MHFZbinaries.7z /tmp/
7z x /tmp/MHFZbinaries.7z \
  -o/home/admin/mhfz/erupe/docker/

# Cleanup
rm /tmp/MHFZbinaries.7z

echo "=== Starting Containers ==="
# Start Erupe
cd ~/mhfz/erupe/docker
docker compose up 

echo "=== Container status ==="
docker compose ps

echo "=== Deploy completed successfully ==="
date