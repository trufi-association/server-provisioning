#!/bin/sh

DIR="$( cd "$( dirname "$0" )" && pwd )"

docker run --rm \
  --volume "$DIR/nginx/www:/var/www" \
  --volume "$DIR/letsencrypt/config:/etc/letsencrypt" \
  --volume "$DIR/letsencrypt/log:/var/log/letsencrypt" \
  --volume "$DIR/letsencrypt/work:/var/lib/letsencrypt" \
  certbot/certbot \
  renew
