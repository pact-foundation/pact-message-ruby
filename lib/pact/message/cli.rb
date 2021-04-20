require 'thor'

module Pact
  module Message
    class CLI < Thor

      method_option :consumer, required: true, desc: "The Consumer name"
      method_option :provider, required: true, desc: "The Provider name"
      method_option :pact_dir, required: true, desc: "The Pact directory"
      method_option :pact_specification_version, required: false, default: "2.0.0", desc: "The Pact Specification version"

      # Update a pact with the given message, or create the pact if it does not exist
      desc 'update MESSAGE_JSON', "Update/create a pact. If MESSAGE_JSON is omitted or '-', it is read from stdin"
      long_desc <<-MSG, wrapping: false
        Update a pact with the given message, or create the pact if it does not exist.
        The MESSAGE_JSON may be in the legacy Ruby JSON format or the v2+ format.
        If MESSAGE_JSON is not provided or is '-', the content will be read from
        standard input.
      MSG
      def update(maybe_json = '-')
        require 'pact/message'
        require 'pact/message/consumer/write_pact'

        message_object = JSON.load(maybe_json == '-' ? $stdin.read : maybe_json)

        pact_specification_version = Pact::SpecificationVersion.new(options.pact_specification_version)
        message_hash = Pact::Message.from_hash(message_object, { pact_specification_version: pact_specification_version })
        Pact::Message::Consumer::WritePact.call(message_hash, options.pact_dir, options.consumer, options.provider, options.pact_specification_version, :update)
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

      no_commands do
        def self.exit_on_failure?
          true
        end
      end
    end
  end
end
