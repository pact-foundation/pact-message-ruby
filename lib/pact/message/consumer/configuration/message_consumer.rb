require 'pact/shared/dsl'
require 'pact/message/consumer/configuration/message_provider'

module Pact
  module Message
    module Consumer
      module Configuration
        class MessageConsumer

          extend Pact::DSL

          attr_accessor :builder, :name

          def initialize name
            @name = name
          end

          dsl do
            def has_pact_with message_provider_name, &block
              MessageProvider.build(message_provider_name, self.name, &block)
            end
          end

          def finalize
            validate
            register_consumer_app if @app
          end

          private

          def validate
            raise "Please provide a consumer name" unless (name && !name.empty?)
          end
        end
      end
    end
  end
end
