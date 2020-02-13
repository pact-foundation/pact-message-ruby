#!/bin/sh
set -e

source script/docker-functions

# avoid accidentally double incrementing when previous run fails
git reset HEAD CHANGELOG.md lib/pact/message/version.rb
git checkout -- lib/pact/message/version.rb
git checkout -- CHANGELOG.md

docker_build_bundle_base

script/release/bump-version.sh $1
VERSION=$(gem_version)

TAG=$VERSION script/release/generate-changelog.sh

git add CHANGELOG.md lib/pact/message/version.rb
git commit -m "chore(release): version ${VERSION}

[ci-skip]"
# bundle exec rake tag_for_release # TODO move release to travis
docker_build_bundle_base
on_docker "bundle exec rake release"
