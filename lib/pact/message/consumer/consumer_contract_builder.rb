require 'pact/message/consumer/interaction_builder'
require 'pact/message/consumer/write_pact'
require 'pact/errors'

module Pact
  module Message
    module Consumer
      class ConsumerContractBuilder

        def initialize(attributes)
          @interaction_builder = nil
          @consumer_name = attributes[:consumer_name]
          @provider_name = attributes[:provider_name]
          @pact_specification_version = attributes[:pact_specification_version]
          @pact_dir = attributes[:pact_dir]
          @interactions = []
          @yielded_interaction = false
        end

        def reset
          @interaction_builder = nil
          @yielded_interaction = false
        end

        def given(provider_state, params = {})
          interaction_builder.given(provider_state, params)
        end

        def is_expected_to_send(description)
          interaction_builder.is_expected_to_send(provider_state)
        end

        def send_message_string
          if interaction_builder?
            if block_given?
              @yielded_interaction = true
              yield interaction_builder.interaction.contents.reified_contents_string
            end
          else
            raise Pact::Error.new("No message expectation has been defined")
          end
        end

        def send_message_hash
          if interaction_builder?
            if block_given?
              @yielded_interaction = true
              yield interaction_builder.interaction.contents.reified_contents_hash
            end
          else
            raise Pact::Error.new("No message expectation has been defined")
          end
        end

        def handle_interaction_fully_defined(interaction)
          @contents = interaction.contents
          @contents_string = interaction.contents.to_s
        end

        def verify example_description
          # There may be multiple message providers defined, and not every one of them
          # has to define a message for every test.
          if interaction_builder?
            if yielded_interaction?
              interactions << interaction_builder.interaction
            else
              raise Pact::Error.new("`send_message_string` was not called for message \"#{interaction_builder.interaction.description}\"")
            end
          end
        end

        def write_pact
          Pact::Message::Consumer::WritePact.call(interactions, pact_dir, consumer_name, provider_name, pact_specification_version, :overwrite)
        end

        private

        attr_accessor :consumer_name, :provider_name, :consumer_contract_details, :contents, :interactions, :pact_specification_version, :pact_dir

        def interaction_builder?
          !!@interaction_builder
        end

        def yielded_interaction?
          @yielded_interaction
        end

        def interaction_builder
          @interaction_builder ||=
          begin
            interaction_builder = InteractionBuilder.new do | interaction |
              handle_interaction_fully_defined(interaction)
            end
            interaction_builder
          end
        end
      end
    end
  end
end
