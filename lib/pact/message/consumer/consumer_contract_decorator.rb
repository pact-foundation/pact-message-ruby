require 'pact/consumer_contract/consumer_contract_decorator'
require 'pact/message/consumer/interaction_decorator'

module Pact
  module Message
    module Consumer
      class ConsumerContractDecorator < Pact::ConsumerContractDecorator


        def as_json(options = {})
          fix_all_the_things(
            consumer: consumer_contract.consumer.as_json,
            provider: consumer_contract.provider.as_json,
            messages: sorted_interactions.collect{ |i| InteractionDecorator.new(i, @decorator_options).as_json},
            metadata: {
              pactSpecification: {
                version: pact_specification_version
              }
            }
          )
        end
      end
    end
  end
end
