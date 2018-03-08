# Developer documentation

## Touchpoints with other gems

Because the HTTP interaction is so baked into the pact gems, the changes required to add message support to the existing code have been spread out across the various gems. I've tried to make extension points where possible in each gem so that pact-http code does not know about or rely on pact-message code at all, but in some places it was unavoidable with the current structure.

### pact-support

To get a Pact::ConsumerContract with messages instead of http interactions (extensible design):

    # lib/pact/message/consumer_contract_parser.rb
    Pact::ConsumerContract.add_parser(Pact::Message::ConsumerContractParser.new)

### pact-mock_service

To write a message pact (extensible design):

    # lib/pact/message/consumer/update_pact.rb
    Pact::ConsumerContractWriter.new(details, Logger.new(StringIO.new))

### pact

To verify a message pact (yucky design, but too much work to separate it nicely right now):

    # lib/pact/provider/rspec.rb

    if interaction.respond_to?(:message?) && interaction.message?
      describe_message Pact::Response.new(interaction.response), interaction_context
    else
      describe "with #{interaction.request.method_and_path}" do
        describe_response Pact::Response.new(interaction.response), interaction_context
      end
    end
