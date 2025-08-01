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
          @interaction.descriptions << description
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
          message_content = Pact::Message::Contents.from_hash(object)
          interaction.events << message_content
          interaction.contents = message_content
          @callback.call interaction
          self
        end
      end
    end
  end
end
