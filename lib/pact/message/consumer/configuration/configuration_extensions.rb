require 'pact/configuration'

module Pact
  module Message
    module Consumer
      module Configuration
        module ConfigurationExtensions
          def add_message_provider_verification &block
            message_provider_verifications << block
          end

          def message_provider_verifications
            @message_provider_verifications ||= []
          end
        end
      end
    end
  end
end
