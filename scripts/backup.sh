#!/bin/bash
set -e

sudo aws s3 sync \
  /opt/erupe/docker/save-backups/ \
  s3://my-mhfz-server-data/backups/