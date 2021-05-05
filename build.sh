#!/bin/bash

REPO_NAME=radpenguin/python-nginx
BUILD_DATE=$(date +"%Y-%m-%d-%H-%M-%S")
VERSION=1.0.0

isTestImage=0
if [[ -z "$1" ]]; then
  isTestImage=1
fi

set -e -u

options=
if [[ $isTestImage -eq 1 ]]; then
  options="--no-cache \
  --build-arg=BUILD_DATE=\"$BUILD_DATE\" \
  --build-arg=VERSION=\"$VERSION\""
fi

docker build \
  $options \
  --tag=$REPO_NAME \
  .

if [[ $isTestImage -eq 0 ]]; then
  docker push $REPO_NAME
fi
