require 'pact/reification'
module Pact
  class ConsumerContract
    class Message
      class Contents
        include ActiveSupportSupport
        include SymbolizeKeys

        # Could technically be an array
        def self.from_hash contents, options = {}
          new(contents)
        end

        def initialize contents
          @contents = contents
        end

        def to_s
          if contents.is_a?(Hash) || contents.is_a?(Array)
            contents.to_json
          else
            contents.to_s
          end
        end

        def reified_contents_string
          if contents.is_a?(Hash) || contents.is_a?(Array)
            Pact::Reification.from_term(contents).to_json
          else
            Pact::Reification.from_term(contents).to_s
          end
        end

        def reified_contents_hash
          Pact::Reification.from_term(contents)
        end

        def contents
          @contents
        end

        def as_json
          @contents
        end
      end
    end
  end
end

module Pact
  module Message
    class Contents
      def self.new *args
        Pact::ConsumerContract::Message::Contents.new(*args)
      end

      def self.from_hash *args
        Pact::ConsumerContract::Message::Contents.from_hash(*args)
      end
    end
  end
end
