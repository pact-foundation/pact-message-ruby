require 'pact/consumer_contract'
require 'pact/consumer_contract/message'
require 'pact/consumer_contract/message/contents'
require 'pact/consumer_contract/provider_state'

module Pact
  module Message
    class ConsumerContractParser
      include SymbolizeKeys

      def call(hash)
        hash = symbolize_keys(hash)
        options = { pact_specification_version: pact_specification_version(hash) }
        interactions = hash[:messages].each_with_index.collect do |hash, index|
          Pact::ConsumerContract::Message.from_hash({ index: index }.merge(hash), options)
        end
        ConsumerContract.new(
          :consumer => ServiceConsumer.from_hash(hash[:consumer]),
          :provider => ServiceProvider.from_hash(hash[:provider]),
          :interactions => interactions
        )
      end

      def can_parse?(hash)
        hash.key?('messages') || hash.key?(:messages)
      end

      def pact_specification_version hash
        # TODO handle all 3 ways of defining this...
        # metadata.pactSpecificationVersion
        maybe_pact_specification_version_1 = hash[:metadata] && hash[:metadata]['pactSpecification'] && hash[:metadata]['pactSpecification']['version']
        maybe_pact_specification_version_2 = hash[:metadata] && hash[:metadata]['pactSpecificationVersion']
        pact_specification_version = maybe_pact_specification_version_1 || maybe_pact_specification_version_2
        pact_specification_version ? Pact::SpecificationVersion.new(pact_specification_version) : Pact::SpecificationVersion::NIL_VERSION
      end
    end
  end
end

Pact::ConsumerContract.add_parser(Pact::Message::ConsumerContractParser.new)