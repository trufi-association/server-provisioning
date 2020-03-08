#!/bin/bash

if [[ $# -lt 2 ]] ; then
    echo 'Missing arguments: <email> <hostname>'
    exit 1
fi

DIR="$( cd "$( dirname "$0" )" && pwd )"

docker run --rm -it \
  --volume "$DIR/nginx/www:/var/www" \
  --volume "$DIR/letsencrypt/config:/etc/letsencrypt" \
  --volume "$DIR/letsencrypt/log:/var/log/letsencrypt" \
  --volume "$DIR/letsencrypt/work:/var/lib/letsencrypt" \
  certbot/certbot \
  certonly --webroot --webroot-path /var/www --email $1 -d $2
