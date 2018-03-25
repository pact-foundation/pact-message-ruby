require 'pact/consumer_contract/message/content'
require 'pact/symbolize_keys'
require 'pact/shared/active_support_support'
require 'pact/matching_rules'
require 'pact/errors'
require 'pact/consumer/request'
require 'pact/consumer_contract/response'
require 'pact/consumer_contract/message/content'

module Pact
  class ConsumerContract
    class Message
      include Pact::ActiveSupportSupport
      include Pact::SymbolizeKeys

        attr_accessor :description, :content, :provider_state

        def initialize attributes = {}
          @description = attributes[:description]
          @provider_state = attributes[:provider_state] || attributes[:providerState]
          @content = attributes[:content]
        end

        def self.from_hash hash, options = {}
          opts = options.dup
          unless opts[:pact_specification_version]
            opts[:pact_specification_version] = Pact::SpecificationVersion::NIL_VERSION
          end
          content_hash = Pact::MatchingRules.merge(hash['content'], hash['content']['matchingRules'], opts)
          content = Pact::ConsumerContract::Message::Content.from_hash(content_hash)
          new(symbolize_keys(hash).merge(content: content))
        end

        def to_hash
          {
            description: description,
            provider_state: provider_state,
            content: content.to_hash,
          }
        end

        # todo move this proper decorator
        def as_json
          {
            description: description,
            providerState: provider_state,
            content: content.as_json
          }
        end

        def request
          @request ||= Pact::Consumer::Request::Actual.from_hash(
            path: '/',
            method: 'POST',
            query: nil,
            headers: {'Content-Type' => 'application/json'},
            body: {
              description: description,
              providerStates: [{
                name: provider_state
              }]
            }
          )
        end

        # custom media type?
        def response
          @response ||= Pact::Response.new(
            status: 200,
            headers: {'Content-Type' => 'application/json'},
            body: {
              content: content
            }
          )
        end

        def http?
          false
        end

        def message?
          true
        end

        def validate!
          raise Pact::InvalidMessageError.new(self) unless description && content
        end

        def == other
          other.is_a?(Message) && to_hash == other.to_hash
        end

        def matches_criteria? criteria
          criteria.each do | key, value |
            unless match_criterion self.send(key.to_s), value
              return false
            end
          end
          true
        end

        def match_criterion target, criterion
          target == criterion || (criterion.is_a?(Regexp) && criterion.match(target))
        end

        def eq? other
          self == other
        end

        def description_with_provider_state_quoted
          provider_state ? "\"#{description}\" given \"#{provider_state}\"" : "\"#{description}\""
        end

        def to_s
          to_hash.to_s
        end
    end
  end
end

module Pact
  module Message
    def self.new *args
      Pact::ConsumerContract::Message.new(*args)
    end

    def self.from_hash *args
      Pact::ConsumerContract::Message.from_hash(*args)
    end
  end
end
