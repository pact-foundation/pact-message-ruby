source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in pact-message.gemspec
gemspec



if ENV['X_PACT_DEVELOPMENT']
  gem "pact-support", path: '../pact-support'
  gem "pact-mock_service", path: '../pact-mock_service'
else
  gem "pact-support", "1.3.0.alpha.1"
  gem "pact-mock_service", "~>2.6", ">=2.6.4"
end
