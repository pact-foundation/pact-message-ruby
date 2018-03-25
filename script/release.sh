#!/bin/bash
set -e

# avoid accidentally double incrementing when previous run fails
git reset HEAD CHANGELOG.md lib/pact/message/version.rb
git checkout -- lib/pact/message/version.rb
git checkout -- CHANGELOG.md
bundle exec bump ${1:-minor} --no-commit
bundle exec rake generate_changelog
git add CHANGELOG.md lib/pact/message/version.rb
git commit -m "chore(release): version $(ruby -r ./lib/pact/message/version.rb -e "puts Pact::Message::VERSION")"
# bundle exec rake tag_for_release # TODO move release to travis
bundle exec rake release
