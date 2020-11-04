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

        def given name, params = {}
          if name
            @interaction.provider_states << Pact::ProviderState.new(name, params)
          end
          self
        end

        alias_method :and, :given

        def with_metadata(object)
          interaction.metadata = object
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
