# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pact/message/version"

Gem::Specification.new do |spec|
  spec.name          = "pact-message"
  spec.version       = Pact::Message::VERSION
  spec.authors       = ["Beth Skurrie"]
  spec.email         = ["beth@bethesque.com"]

  spec.summary       = %q{Consumer contract library for messages}
  spec.homepage      = "http://pact.io"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "pact-support", "~> 1.8"
  # pact-mock_service dependencies are Pact::ConsumerContractDecorator
  # and Pact::ConsumerContractWriter. Potentially we should extract
  # or duplicate these classes to remove the pact-mock_service dependency.
  spec.add_runtime_dependency "pact-mock_service", "~> 3.1"
  spec.add_runtime_dependency "thor", '>= 0.20', '< 2.0'

  spec.add_development_dependency "rake", "~> 12.3", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency 'conventional-changelog', '~>1.2'
  spec.add_development_dependency 'bump', '~> 0.5'
end
