#!/bin/bash
set -e

bundle exec bump ${1:-minor} --no-commit
bundle exec rake generate_changelog
git add CHANGELOG.md lib/pact/message/version.rb
bundle exec rake tag_for_release
bundle exec rake release
