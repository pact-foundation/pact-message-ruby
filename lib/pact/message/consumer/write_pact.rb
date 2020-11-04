require 'pact/consumer_contract/consumer_contract_writer'
require 'pact/message/consumer/consumer_contract_decorator'

module Pact
  module Message
    module Consumer
      class WritePact

        def initialize messages, pact_dir, consumer_name, provider_name, pact_specification_version, pactfile_write_mode
          @pact_dir = pact_dir
          @messages = messages
          @consumer_name = consumer_name
          @provider_name = provider_name
          @pact_specification_version = pact_specification_version
          @pactfile_write_mode = pactfile_write_mode
        end

        def self.call(messages, pact_dir, consumer_name, provider_name, pact_specification_version, pactfile_write_mode)
          new(messages, pact_dir, consumer_name, provider_name, pact_specification_version, pactfile_write_mode).call
        end

        def call
          details = {
            consumer: { name: consumer_name },
            provider: { name: provider_name },
            interactions: [*messages],
            pactfile_write_mode: pactfile_write_mode,
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

        attr_reader :messages, :pact_dir, :consumer_name, :provider_name, :pact_specification_version, :pactfile_write_mode
      end
    end
  end
end
