require 'pact/consumer_contract'
require 'pact/consumer_contract/message'
require 'pact/consumer_contract/message/content'

module Pact
  module Message
    class ConsumerContractParser
      include SymbolizeKeys

      def call(hash)
        hash = symbolize_keys(hash)
        interactions = hash[:messages].collect { |hash| Pact::ConsumerContract::Message.from_hash(hash)}
        ConsumerContract.new(
          :consumer => ServiceConsumer.from_hash(hash[:consumer]),
          :provider => ServiceProvider.from_hash(hash[:provider]),
          :interactions => interactions
        )
      end

      def can_parse?(hash)
        hash.key?('messages') || hash.key?(:messages)
      end
    end
  end
end

Pact::ConsumerContract.add_parser(Pact::Message::ConsumerContractParser.new)