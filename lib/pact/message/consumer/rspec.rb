require 'rspec'
require 'pact/message/consumer/consumer_contract_builders'

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

RSpec.configure do |config|
  config.include Pact::Message::Consumer::RSpec, :pact => :message
end
