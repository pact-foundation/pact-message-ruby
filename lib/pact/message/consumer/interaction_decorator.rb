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
          hash[:providerStates] = provider_states
          hash[:contents] = extract_contents
          hash[:matchingRules] = extract_matching_rules
          hash[:metaData] = message.metadata || {}
          fix_all_the_things hash
        end

        def to_json(options = {})
          as_json(options).to_json(options)
        end

        private

        attr_reader :message

        def decorate_contents
          message.contents.as_json
        end

        def extract_contents
          Pact::Reification.from_term(message.contents.contents)
        end

        def provider_states
          message.provider_states.collect(&:as_json)
        end

        def extract_matching_rules
          {
            body: Pact::MatchingRules.extract(message.contents.contents, pact_specification_version: pact_specification_version)
          }
        end

        def pact_specification_version
          Pact::SpecificationVersion.new(@decorator_options[:pact_specification_version])
        end
      end
    end
  end
end
