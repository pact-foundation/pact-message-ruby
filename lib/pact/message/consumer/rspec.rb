require 'rspec'
require 'pact/message/consumer/consumer_contract_builders'
# require 'pact/message/consumer/spec_hooks'

module Pact
  module Message
    module Consumer
      module RSpec
        include Pact::Message::Consumer::ConsumerContractBuilders
        # include Pact::Helpers
      end
    end
  end
end

# hooks = Pact::Consumer::SpecHooks.new

RSpec.configure do |config|
  config.include Pact::Message::Consumer::RSpec, :pact => :message

  # config.before :all, :pact => true do
  #   hooks.before_all
  # end

  # config.before :each, :pact => true do | example |
  #   hooks.before_each Pact::RSpec.full_description(example)
  # end

  # config.after :each, :pact => true do | example |
  #   hooks.after_each Pact::RSpec.full_description(example)
  # end

  # config.after :suite do
  #   hooks.after_suite
  # end
end
