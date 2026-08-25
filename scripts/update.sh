#!/bin/bash
set -e

# Get current public IPv4
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

# Download configuration and insert current IP
curl -L "https://raw.githubusercontent.com/edwardkuehne-sys/MhfzAWSDeployment/refs/heads/main/config/config.json" \
  -o /tmp/config.json

sed "s/YOUR_PUBLIC_IP/$PUBLIC_IP/g" \
  /tmp/config.json \
  > ~/mhfz/erupe/docker/config.json

cd ~/mhfz/erupe/docker

sudo docker-compose down
sudo docker-compose build
sudo docker-compose up -d