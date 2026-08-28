#!/bin/bash

set -e

cd /home/admin/mhfz/erupe/docker

# Stop Erupe containers
docker compose down

# Get current public IP
TOKEN=$(curl -sS -X PUT \
  "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

PUBLIC_IP=$(curl -sS \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  "http://169.254.169.254/latest/meta-data/public-ipv4")

echo "Public IPv4: $PUBLIC_IP"

# Update config
# TODO this hard coded value is bad if other user's configs look different
sed -i '2s/"Host": "[^"]*"/"Host": "'"$PUBLIC_IP"'"/' config.json

# Start Erupe with updated config
docker compose up -d