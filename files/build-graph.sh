#!/bin/bash

if [[ $# -lt 3 ]] ; then
    echo 'Missing arguments: <region> <pbf url> <bbox>'
    echo 'e.g. "bolivia-cochabamba" "https://download.geofabrik.de/south-america/bolivia-latest.osm.pbf" "-66.376555,-17.57727,-65.96397,-17.276198"'
    exit 1
fi

TARGET=$1
PBF_URL=$2
BBOX=$3

TMP="/tmp"
DIR="$( cd "$( dirname "$0" )" && pwd )"
GRAPHDIR=$DIR/graphs
IMAGE_PREFIX="docker.pkg.github.com/trufi-association/tools"

if [ ! -d "$GRAPHDIR" ]; then
  echo "Directory $GRAPHDIR does not exist"
  exit 1
fi

echo "Building GTFS from OSM data ..."
docker run \
  --rm \
  --volume $GRAPHDIR/$TARGET:/data \
  --env TARGET=$TARGET \
  --env FILENAME=osm-gtfs.zip \
  $IMAGE_PREFIX/fetch-gtfs:latest
rc=$?

if [[ $rc != 0 ]]; then
  echo "Failed"
  exit $rc
else
  echo "Done"
fi

echo "Update OSM PBF extract ..."
curl $PBF_URL --output $TMP/input.pbf
docker run \
  --workdir /tmp \
  --volume $TMP:/tmp \
  $IMAGE_PREFIX/osmium:latest extract \
    --bbox $BBOX \
    --output /tmp/output.pbf \
    /tmp/input.pbf
mv -f $TMP/output.pbf $GRAPHDIR/$TARGET/$TARGET.osm.pbf
rm -f $TMP/input.pbf
echo "Done"

echo "Building OTP Graph ..."
docker run \
  --rm \
  --tty \
  --volume $GRAPHDIR:/var/otp/graphs \
  $IMAGE_PREFIX/opentripplanner:latest --build $TARGET
rc=$?

if [[ $rc != 0 ]]; then
  echo "Failed"
  exit $rc
else
  echo "Done"
fi
