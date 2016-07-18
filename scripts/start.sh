#!/bin/bash
# tbd

# Stop on error
set -e

# Start apache
/usr/local/apache2/bin/apachectl -k start

# Keep container up with ping
ping -i 60 www.google.com
