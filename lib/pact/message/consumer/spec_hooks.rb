require 'pact/message/consumer/world'

module Pact
  module Message
    module Consumer
      class SpecHooks
        def before_each example_description
          Pact::Message.consumer_world.register_pact_example_ran
          Pact::Message.consumer_world.consumer_contract_builders.each(&:reset)
        end

        def after_each example_description
          Pact.configuration.message_provider_verifications.each do | message_provider_verification |
            message_provider_verification.call example_description
          end
        end

        def after_suite
          if Pact::Message.consumer_world.any_pact_examples_ran?
            Pact::Message.consumer_world.consumer_contract_builders.each(&:write_pact)
          end
        end
      end
    end
  end
end
