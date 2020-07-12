#!/bin/bash

if [[ $# -lt 2 ]] ; then
    echo 'Missing arguments: <otp graphs dir> <target graph dir>'
    exit 1
fi

GRAPHDIR=$1
TARGET=$2

if [ ! -d "$GRAPHDIR/$TARGET" ]; then
  echo "Directory $GRAPHDIR/$TARGET does not exist"
  exit 1
fi

echo "Building OTP Graph ..."
docker run \
  --rm \
  --tty \
  --volume $GRAPHDIR:/var/otp/graphs \
  docker.pkg.github.com/trufi-association/tools/opentripplanner:latest --build $TARGET
rc=$?

if [[ $rc != 0 ]]; then
  echo "Failed"
  exit $rc
else
  echo "Done"
fi
