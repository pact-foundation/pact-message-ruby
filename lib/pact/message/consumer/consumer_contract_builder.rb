require 'pact/message/consumer/interaction_builder'
require 'pact/consumer_contract/file_name'
require 'pact/consumer_contract/pact_file'
require 'filelock'

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
          }
          @consumer_name = attributes[:consumer_name]
          @provider_name = attributes[:provider_name]
            # pactfile_write_mode: attributes[:pactfile_write_mode].to_s,
            # pact_dir: attributes.fetch(:pact_dir)

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

          FileUtils.mkdir_p(File.dirname(pact_file_path))
          Filelock pact_file_path do | file |
            new_contents = pact_json(interaction)
            file.truncate 0
            file.write new_contents
          end

        end

        private

        attr_writer :interaction_builder
        attr_accessor :consumer_name, :provider_name

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
