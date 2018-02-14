require 'pact/message/consumer/interaction_builder'
require 'pact/consumer_contract/file_name'
require 'pact/consumer_contract/pact_file'
require 'pact/consumer_contract/consumer_contract_writer'
require 'pact/message/consumer/consumer_contract_decorator'

module Pact
  module Message
    module Consumer
      class ConsumerContractBuilder

        include Pact::FileName
        include Pact::PactFile

        def initialize(attributes)
          @interaction_builder = nil
          @consumer_contract_details = {
            consumer: {name: attributes[:consumer_name]},
            provider: {name: attributes[:provider_name]},
            pactfile_write_mode: :update,
            pact_dir: "./spec/pacts",
            error_stream: StringIO.new,
            output_stream: StringIO.new,
            consumer_contract_decorator_class: Pact::Message::Consumer::ConsumerContractDecorator

          }
          @consumer_name = attributes[:consumer_name]
          @provider_name = attributes[:provider_name]
        end

        def given(provider_state)
          interaction_builder.given(provider_state)
        end

        def description(description)
          interaction_builder.description(provider_state)
        end

        def yield_message
          yield @content_string if block_given?
        end

        def handle_interaction_fully_defined(interaction)
          @content_string = interaction.content.to_s
          @interaction_builder = nil

          details = consumer_contract_details.merge(interactions: [interaction])
          writer = Pact::ConsumerContractWriter.new(details, Logger.new(StringIO.new))
          writer.write

          # FileUtils.mkdir_p(File.dirname(pact_file_path))
          # Filelock pact_file_path do | file |
          #   new_contents = pact_json(interaction)
          #   file.truncate 0
          #   file.write new_contents
          # end
        end

        private

        attr_writer :interaction_builder
        attr_accessor :consumer_name, :provider_name, :consumer_contract_details

        def pact_json(interaction)
          contract = read_contract
          index = find_index_of_interaction(contract, interaction)
          if index
            contract[:messages][index] == interaction.as_json
          else
            contract[:messages] << interaction.as_json
          end

          JSON.pretty_generate(contract)

        end

        def pact_file_path
          file_path(consumer_name, provider_name, "./spec/pacts")
        end

        def read_contract
          if File.exist?(pact_file_path) && File.size(pact_file_path) > 0
            JSON.parse(File.read(pact_file_path), symbolize_names: true)
          else
            {
              consumer: {name: consumer_name},
              provider: {name: provider_name},
              messages: []
            }
          end
        end

        def find_index_of_interaction(contract_hash, new_interaction)
          contract_hash[:messages].find_index do | interaction |
            interaction[:providerState] == new_interaction.provider_state &&
              interaction[:description] == new_interaction.description
          end
        end

        def interaction_builder
          @interaction_builder ||=
          begin
            interaction_builder = InteractionBuilder.new do | interaction |
              handle_interaction_fully_defined(interaction)
            end
            interaction_builder
          end
        end
      end
    end
  end
end
