source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in pact-message.gemspec
gemspec



if ENV['X_PACT_DEVELOPMENT']
  gem "pact-support", path: '../pact-support'
  gem "pact-mock_service", path: '../pact-mock_service'
else
  gem "pact-support", git: "https://github.com/pact-foundation/pact-support.git", ref: "2e488923afedda02960a01dc8c38cef347e48ab1"
  gem "pact-mock_service", git: "https://github.com/pact-foundation/pact-mock_service", ref: "1856f217237080b16aa89acec18af15a39d08f80"
end
