require 'pact/shared/active_support_support'

module Pact
  module Message
    module Consumer
      class InteractionDecorator

        include ActiveSupportSupport

        def initialize message, decorator_options = {}
          @message = message
          @decorator_options = decorator_options
        end

        def as_json options = {}
          hash = { :description => message.description }
          hash[:providerStates] = provider_states if message.provider_state
          hash[:content] = extract_content
          hash[:matchingRules] = extract_matching_rules
          fix_all_the_things hash
        end

        def to_json(options = {})
          as_json(options).to_json(options)
        end

        private

        attr_reader :message

        def decorate_content
          message.content.as_json
        end

        def extract_content
          Pact::Reification.from_term(message.content.content)
        end

        def provider_states
          [{ name: message.provider_state }]
        end

        def extract_matching_rules
          {
            body: Pact::MatchingRules.extract(message.content.content, pact_specification_version: pact_specification_version)
          }
        end

        def pact_specification_version
          Pact::SpecificationVersion.new(@decorator_options[:pact_specification_version])
        end
      end
    end
  end
end
