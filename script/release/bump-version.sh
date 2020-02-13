#!/usr/bin/env sh

source script/docker-functions

on_docker "bundle exec bump ${1:-minor} --no-commit"
