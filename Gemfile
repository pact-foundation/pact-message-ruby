source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in pact-message.gemspec
gemspec

if ENV['X_PACT_DEVELOPMENT']
  gem "pact-support", path: '../pact-support'
  gem "pact-mock_service", path: '../pact-mock_service'
end
