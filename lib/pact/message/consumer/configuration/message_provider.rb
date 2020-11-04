require 'pact/shared/dsl'
require 'pact/message/consumer/configuration/message_builder'

module Pact
  module Message
    module Consumer
      module Configuration
        class MessageProvider

          extend Pact::DSL

          attr_accessor :builder, :consumer_name, :name

          def initialize name, consumer_name
            @name = name
            @builder = nil
            @consumer_name = consumer_name
          end

          dsl do
            def mock_provider(builder_name, &block)
              self.builder = MessageBuilder.build(builder_name, consumer_name, name, &block)
            end

            def builder(builder_name, &block)
              expectation_builder(builder_name, &block)
            end
          end

          def finalize
            validate
          end

          private

          def validate
            raise "Please configure a name for the message provider" unless name
          end
        end
      end
    end
  end
end
