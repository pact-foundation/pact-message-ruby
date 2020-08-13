require 'pact/message/consumer/interaction_builder'
require 'pact/message/consumer/update_pact'

module Pact
  module Message
    module Consumer
      class ConsumerContractBuilder

        def initialize(attributes)
          @interaction_builder = nil
          @consumer_name = attributes[:consumer_name]
          @provider_name = attributes[:provider_name]
          @interactions = []
        end

        def given(provider_state)
          interaction_builder.given(provider_state)
        end

        def is_expected_to_send(description)
          interaction_builder.is_expected_to_send(provider_state)
        end

        def send_message_string
          yield contents.reified_contents_string if block_given?
        end

        def handle_interaction_fully_defined(interaction)
          @contents = interaction.contents
          @contents_string = interaction.contents.to_s
          @interactions << interaction
          @interaction_builder = nil
          # TODO pull these from pact config
          Pact::Message::Consumer::UpdatePact.call(interaction, "./spec/pacts", consumer_name, provider_name, "2.0.0")
        end

        def verify example_description
          #
          # TODO check that message was actually yielded
        end

        private

        attr_writer :interaction_builder
        attr_accessor :consumer_name, :provider_name, :consumer_contract_details, :contents

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
