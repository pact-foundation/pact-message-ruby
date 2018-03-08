module Pact
  module Message

  end
end

require "pact/message/version"
require "pact/message/consumer/configuration"
# Require this after so that Pact::Message.new and Pact::Message.from_hash
# are defined correctly in pact-support/lib/pact/consumer_contract/message.rb
require "pact/support"
require "pact/consumer_contract/message"
require "pact/consumer_contract/message/content"
