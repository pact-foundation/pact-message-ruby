#!/bin/bash
set -e

git reset HEAD CHANGELOG.md lib/pact/message/version.rb # avoid accidentally double incrementing when previous run fails
git checkout -- lib/pact/message/version.rb # avoid accidentally double incrementing when previous run fails
# git checkout -- CHANGELOG.md # avoid accidentally double incrementing when previous run fails
bundle exec bump ${1:-minor} --no-commit
bundle exec rake generate_changelog
git add CHANGELOG.md lib/pact/message/version.rb
git commit -m "chore(release): version $(ruby -r ./lib/pact/message/version.rb -e "puts Pact::Message::VERSION")"
bundle exec rake tag_for_release
bundle exec rake release
