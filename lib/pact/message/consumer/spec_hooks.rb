module Pact
  module Message
    module Consumer
      class SpecHooks
        def after_each example_description
          Pact.configuration.message_provider_verifications.each do | message_provider_verification |
            message_provider_verification.call example_description
          end
        end
      end
    end
  end
end
