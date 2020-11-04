require 'pact/message/consumer/consumer_contract_builder'
require 'pact/message/consumer/consumer_contract_builders'
require 'pact/message/consumer/world'

module Pact
  module Message
    module Consumer
      module Configuration
        class MessageBuilder

          extend Pact::DSL

          attr_accessor :provider_name, :consumer_name, :pact_specification_version

          def initialize name, consumer_name, provider_name
            @name = name
            @consumer_name = consumer_name
            @provider_name = provider_name
            @pact_specification_version = nil
          end

          dsl do
            def pact_specification_version pact_specification_version
              self.pact_specification_version = pact_specification_version
            end
          end

          def finalize
            configure_consumer_contract_builder
          end

          private

          def configure_consumer_contract_builder
            consumer_contract_builder = create_consumer_contract_builder
            create_consumer_contract_builders_method consumer_contract_builder
            setup_verification(consumer_contract_builder)
            consumer_contract_builder
          end

          def create_consumer_contract_builder
            consumer_contract_builder_fields = {
              consumer_name: consumer_name,
              provider_name: provider_name,
              pact_specification_version: pact_specification_version,
              pact_dir: Pact.configuration.pact_dir
            }
            Pact::Message::Consumer::ConsumerContractBuilder.new consumer_contract_builder_fields
          end

          def setup_verification consumer_contract_builder
            Pact.configuration.add_message_provider_verification do | example_description |
              consumer_contract_builder.verify example_description
            end
          end

          def create_consumer_contract_builders_method consumer_contract_builder
            Pact::Message::Consumer::ConsumerContractBuilders.send(:define_method, @name.to_sym) do
              consumer_contract_builder
            end

            Pact::Message.consumer_world.add_consumer_contract_builder consumer_contract_builder
          end
        end
      end
    end
  end
end
