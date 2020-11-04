require 'rspec'
require 'pact/rspec'
require 'pact/message/consumer/consumer_contract_builders'
require 'pact/message/consumer/spec_hooks'
require 'pact/helpers'

module Pact
  module Message
    module Consumer
      module RSpec
        include Pact::Message::Consumer::ConsumerContractBuilders
        include Pact::Helpers
      end
    end
  end
end

hooks = Pact::Message::Consumer::SpecHooks.new

RSpec.configure do |config|
  config.include Pact::Message::Consumer::RSpec, :pact => :message

  config.before :each, :pact => :message do | example |
    hooks.before_each Pact::RSpec.full_description(example)
  end

  config.after :each, :pact => :message do | example |
    hooks.after_each Pact::RSpec.full_description(example)
  end

  config.after :all do
    hooks.after_suite
  end
end
