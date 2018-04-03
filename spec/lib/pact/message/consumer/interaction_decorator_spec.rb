require 'pact/message/consumer/interaction_decorator'
require 'pact/support'
module Pact
  module Message
    module Consumer
      ::RSpec.describe InteractionDecorator do
        describe "#as_json" do
          let(:message) do
            double('Pact::ConsumerContract::Message',
              description: 'description',
              provider_state: 'provider state',
              content: double('Pact::ConsumerContract::Message::Content', content: content_object)
              )
          end
          let(:content_object) do
            { 'foo' => Pact.like('bar') }
          end
          let(:options) { { pact_specification_version: "3.0.0" } }

          subject { InteractionDecorator.new(message, options).as_json }

          let(:expected) do
            {
              description: 'description',
              providerStates: [ { name: 'provider state' } ],
              content: {
                'foo' => 'bar'
              },
              matchingRules: {
                body: {
                  '$.foo' => {
                    'matchers' => [
                      { 'match' => 'type' }
                    ]
                  }
                }
              }
            }
          end

          it "returns a JSON description of the message using the v3 pact specification" do
            expect(subject).to eq expected
          end
        end
      end
    end
  end
end
