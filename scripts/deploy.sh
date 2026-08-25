#!/bin/bash
set -e

echo "=== Deploy started ==="
date

echo "=== Cloning Erupe ==="
git clone https://github.com/Mezeporta/Erupe.git ~/mhfz/erupe

echo "=== Configuring Erupe ==="
# Edit in the docker-compose yaml to build images locally
sed -i '/^[[:space:]]*image: ghcr.io\/mezeporta\/erupe:main$/c\
    build:\
      context: ../' ~/mhfz/erupe/docker/docker-compose.yml

echo "=== Extracting MHFZ binaries ==="
# Download the permanent game binaries from S3
aws s3 cp s3://my-mhfz-server-data/MHFZbinaries.7z /tmp/
7z x /tmp/MHFZbinaries.7z \
  -o/home/admin/mhfz/erupe/docker/

# Cleanup
rm /tmp/MHFZbinaries.7z

echo "=== Building Erupe ==="
# Start Erupe
cd ~/mhfz/erupe/docker
docker compose up --build

echo "=== Container status ==="
docker compose ps

echo "=== Deploy completed successfully ==="
date