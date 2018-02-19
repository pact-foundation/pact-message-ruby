require 'pact/consumer_contract/consumer_contract_writer'
require 'pact/message/consumer/consumer_contract_decorator'

module Pact
  module Message
    module Consumer
      class UpdatePact

        def initialize message, pact_dir, consumer_name, provider_name, pact_specification_version
          @pact_dir = pact_dir
          @message = message
          @consumer_name = consumer_name
          @provider_name = provider_name
          @pact_specification_version = pact_specification_version
        end

        def self.call(message, pact_dir, consumer_name, provider_name, pact_specification_version)
          new(message, pact_dir, consumer_name, provider_name, pact_specification_version).call
        end

        def call
          details = {
            consumer: {name: consumer_name},
            provider: {name: provider_name},
            interactions: [message],
            pactfile_write_mode: :update,
            pact_dir: pact_dir,
            pact_specification_version: pact_specification_version,
            error_stream: StringIO.new,
            output_stream: StringIO.new,
            consumer_contract_decorator_class: Pact::Message::Consumer::ConsumerContractDecorator
          }
          writer = Pact::ConsumerContractWriter.new(details, Logger.new(StringIO.new))
          writer.write
        end

        private

        attr_reader :message, :pact_dir, :consumer_name, :provider_name, :pact_specification_version
      end
    end
  end
end
