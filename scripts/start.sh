#!/bin/bash
# Starts up Nginx within the container.

# Stop on error
set -e

DATA_DIR=/srv/www
LOG_DIR=/var/log
 
# Check if the data directory does not exist.
if [ ! -d "$LOG_DIR/nginx" ]; then
  mkdir -p "$LOG_DIR/nginx"
fi

if [[ -e /first_run ]]; then
  source /app/scripts/first_run.sh
else
  source /app/scripts/normal_run.sh
fi

# not sure why this cmd is failing
# chown -R nginx:nginx "$LOG_DIR/nginx"

# not installed
# echo "Starting Syslog-ng..."
# syslog-ng --no-caps

echo "Starting Nginx..."
/usr/sbin/nginx

echo "Pinging Google...."
ping -i 60 www.google.com
