source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in pact-message.gemspec
gemspec


gem "pact-support", git: "git@github.com:pact-foundation/pact-support.git", ref: "2e488923afedda02960a01dc8c38cef347e48ab1"

if ENV['X_PACT_DEVELOPMENT']
  gem "pact-support", path: '../pact-support'
end
