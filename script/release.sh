#!/bin/sh
set -e

source script/docker-functions

# avoid accidentally double incrementing when previous run fails
git reset HEAD CHANGELOG.md lib/pact/message/version.rb
git checkout -- lib/pact/message/version.rb
git checkout -- CHANGELOG.md

docker_build_bundle_base

script/release/bump-version.sh $1
script/release/generate-changelog.sh

git add CHANGELOG.md lib/pact/message/version.rb
git commit -m "chore(release): version ${VERSION}

[ci-skip]"

VERSION=$(gem_version)
TAG="v${VERSION}"
git tag -a "${TAG}" -m "Releasing version ${TAG}"
git push origin "${TAG}"
git push origin master
echo "Releasing from https://travis-ci.org/pact-foundation/pact-message-ruby/builds"
