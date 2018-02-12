require 'pact/message/consumer/configuration/message_consumer'

module Pact
  module Message
    module Consumer
      module DSL
        def message_consumer name, &block
          Configuration::MessageConsumer.build(name, &block)
        end
      end
    end
  end
end
