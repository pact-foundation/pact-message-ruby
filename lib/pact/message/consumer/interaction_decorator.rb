require 'pact/shared/active_support_support'

module Pact
  module Message
    module Consumer
      class InteractionDecorator

        include ActiveSupportSupport

        def initialize interaction, decorator_options = {}
          @interaction = interaction
          @decorator_options = decorator_options
        end

        def as_json options = {}
          hash = { :description => interaction.description }
          hash[:providerState] = interaction.provider_state if interaction.provider_state
          hash[:content] = decorate_content
          fix_all_the_things hash
        end

        def to_json(options = {})
          as_json(options).to_json(options)
        end

        private

        attr_reader :interaction

        def decorate_content
          interaction.content.as_json
        end
      end
    end
  end
end
