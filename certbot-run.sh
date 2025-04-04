#!/bin/bash

# 💬 Make sure ports 80 & 443 are forwarded & nginx is OFF for this
docker run -it --rm \
  -v "$(pwd)/certs:/etc/letsencrypt" \
  -v "$(pwd)/html:/var/www/html" \
  certbot/certbot certonly \
  --standalone \
  --non-interactive \
  --agree-tos \
  --email skippy5439812@gmail.com \
  -d ericjensen.cam -d www.ericjensen.cam
