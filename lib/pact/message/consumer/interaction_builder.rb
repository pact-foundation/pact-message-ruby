require 'pact/reification'
require 'pact/consumer_contract/message'

module Pact
  module Message
    module Consumer
      class InteractionBuilder

        attr_reader :interaction

        def initialize &block
          @interaction = Pact::ConsumerContract::Message.new
          @callback = block
        end

        def description description
          @interaction.description = description
          self
        end

        def given provider_state
          @interaction.provider_state = provider_state.nil? ? nil : provider_state.to_s
          self
        end

        def content(object)
          interaction.content = Pact::ConsumerContract::Message::Content.new(object)
          @callback.call interaction
          self
        end
      end
    end
  end
end
