#!/bin/bash
set -e

echo "=== Deploy started ==="
date

echo "=== Cloning Erupe ==="
git clone https://github.com/Mezeporta/Erupe.git ~/mhfz/erupe
cd ~/mhfz/erupe
git checkout 531b3d2fa6af9b102f775d1630360605abc0ac67

echo "=== Configuring Erupe ==="
# Replace their server image with my own
echo "=== Replacing local build in docker compose with prebuilt image ==="
sed -i '/^    build:$/,+1c\
    image: anononetwothree/mhfz-erupe:stable' ~/mhfz/erupe/docker/docker-compose.yml

echo "=== Replacing sql file in init script ==="
cp /opt/mhfz-deployment/db/init.sql ~/mhfz/erupe/schemas/init.sql

echo "=== Retrieving public IPv4 for config ==="
TOKEN=$(curl -sS -X PUT \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
  http://169.254.169.254/latest/api/token)

PUBLIC_IP=$(curl -sS --fail \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-ipv4)

echo "=== Inserting public IPv4 into config ==="
sed "s/PUBLIC_IP/$PUBLIC_IP/g" \
  /opt/mhfz-deployment/config/config.json \
  > ~/mhfz/erupe/docker/config.json

echo "== Configuration successful ==="

echo "=== Extracting MHFZ binaries ==="
# Download the permanent game binaries from S3
aws s3 cp s3://my-mhfz-server-data/MHFZbinaries.7z /tmp/
7z x /tmp/MHFZbinaries.7z \
  -o/home/admin/mhfz/erupe/docker/
# Cleanup
rm /tmp/MHFZbinaries.7z

echo "=== Starting Containers ==="
cd ~/mhfz/erupe/docker
# Set restart policy
yq -y -i '
  .services |= with_entries(
    .value.restart = "unless-stopped"
  )
' docker-compose.yml
# Start Erupe
docker compose up -d --force-recreate

echo "=== Container status ==="
docker compose ps

echo "=== Deploy completed successfully ==="
date