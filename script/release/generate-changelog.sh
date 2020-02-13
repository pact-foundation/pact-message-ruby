#!/usr/bin/env sh

set -e

: "${TAG:?Please set the TAG environment variable}"

source script/docker-functions

docker run --rm -it \
  -e TAG=${TAG} \
  -v ${PWD}:/app \
  ${IMAGE} \
  sh -c "bundle exec rake generate_changelog"

