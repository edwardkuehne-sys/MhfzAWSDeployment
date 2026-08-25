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
cp /opt/mhfz-deployment/config/config.json ~/mhfz/erupe/docker/config.json

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