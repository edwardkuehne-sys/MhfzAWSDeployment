#!/bin/bash
set -e

# Clone Erupe
git clone https://github.com/Mezeporta/Erupe.git ~/mhfz/erupe

# Get the EC2 instance's public IPv4 address
TOKEN=$(curl -sX PUT \
  "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

PUBLIC_IP=$(curl -s \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-ipv4)

if [ -z "$PUBLIC_IP" ]; then
    echo "ERROR: Could not determine public IPv4 address"
    exit 1
fi

# Insert the actual public IP into the config
sed "s/YOUR_PUBLIC_IP/$PUBLIC_IP/g" \
  /opt/mhfz-deployment/config/config.json \
  > ~/mhfz/erupe/docker/config.json

# Download the permanent game binaries from S3
aws s3 cp s3://my-mhfz-server-data/MHFZbinaries.7z /tmp/
7z x /tmp/MHFZbinaries.7z \
  -o/home/admin/mhfz/erupe/docker/

# Cleanup
rm /tmp/MHFZbinaries.7z

# Start Erupe
cd ~/mhfz/erupe/docker
docker-compose up -d