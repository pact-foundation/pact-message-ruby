module Pact
  module Message
    module Consumer
      class Message
        attr_accessor :description, :content, :provider_state

        def initialize attributes = {}
          @description = attributes[:description]
          @provider_state = attributes[:provider_state] || attributes[:providerState]
          @content = attributes[:content]
        end

        def to_hash
          {
            description: description,
            provider_state: provider_state,
            content: content
          }
        end

        def to_json
          {
            description: description,
            providerState: provider_state,
            content: content
          }
        end
      end
    end
  end
end
