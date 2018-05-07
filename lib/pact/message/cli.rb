require 'thor'

module Pact
  module Message
    class CLI < Thor

      method_option :consumer, required: true, desc: "The Consumer name"
      method_option :provider, required: true, desc: "The Provider name"
      method_option :pact_dir, required: true, desc: "The Pact directory"
      method_option :pact_specification_version, required: false, default: "2.0.0", desc: "The Pact Specification version"

      desc 'update MESSAGE_JSON', 'Update a pact with the given message, or create the pact if it does not exist. The MESSAGE_JSON may be in the legacy Ruby JSON format or the v2+ format.'
      def update(message)
        require 'pact/message'
        require 'pact/message/consumer/update_pact'
        pact_specification_version = Pact::SpecificationVersion.new(options.pact_specification_version)
        message = Pact::Message.from_hash(JSON.load(message), { pact_specification_version: pact_specification_version })
        Pact::Message::Consumer::UpdatePact.call(message, options.pact_dir, options.consumer, options.provider, options.pact_specification_version)
      end

      desc 'reify', "Take a JSON document with embedded pact matchers and return a concrete example"
      def reify(json)
        require 'pact/support'
        puts Pact::Reification.from_term(JSON.load(json)).to_json
      end

      desc 'version', "Show the pact-message gem version"
      def version
        require 'pact/message/version.rb'
        puts Pact::Message::VERSION
      end
    end
  end
end
