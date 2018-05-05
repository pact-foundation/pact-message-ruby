require 'pact/reification'

module Pact
  module Message
    module Consumer
      class InteractionBuilder

        attr_reader :interaction

        def initialize &block
          @interaction = Pact::Message.new
          @callback = block
        end

        def is_expected_to_send description
          @interaction.description = description
          self
        end

        def given provider_state
          @interaction.provider_state = provider_state.nil? ? nil : provider_state.to_s
          self
        end

        def with_metadata(object)
          # TODO implement this
          self
        end

        def with_content(object)
          interaction.contents = Pact::Message::Contents.from_hash(object)
          @callback.call interaction
          self
        end
      end
    end
  end
end
