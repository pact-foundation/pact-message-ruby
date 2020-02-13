#!/usr/bin/env sh

set -e

source script/docker-functions
on_docker "bundle exec rake generate_changelog"
