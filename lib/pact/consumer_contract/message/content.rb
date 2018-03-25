module Pact
  class ConsumerContract
    class Message
      class Content
        include ActiveSupportSupport
        include SymbolizeKeys

        # Could technically be an array
        def self.from_hash content, options = {}
          new(content)
        end

        def initialize content
          @content = content
        end

        def to_s
          if @content.is_a?(Hash) || @content.is_a?(Array)
            @content.to_json
          else
            @content.to_s
          end
        end

        def as_json
          @content
        end
      end
    end
  end
end

module Pact
  module Message
    class Content
      def self.new *args
        Pact::ConsumerContract::Message::Content.new(*args)
      end

      def self.from_hash *args
        Pact::ConsumerContract::Message::Content.from_hash(*args)
      end
    end
  end
end
