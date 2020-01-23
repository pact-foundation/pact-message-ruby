require 'pact/message/consumer_contract_parser'

module Pact
  module Message
    ::RSpec.describe ConsumerContractParser do

      let(:loaded_pact) { ConsumerContract.from_json(string) }

      context "with a Message contract" do
        let(:string) { File.read('spec/fixtures/message-pact-v3-format.json') }

        it "creates a Pact" do
          expect(loaded_pact).to be_instance_of ConsumerContract
        end

        it "has messages" do
          expect(loaded_pact.interactions).to be_instance_of Array
          expect(loaded_pact.interactions.first).to be_instance_of Pact::ConsumerContract::Message
        end

        it "has a consumer" do
          expect(loaded_pact.consumer.name).to eq "Bob"
        end

        it "has a provider" do
          expect(loaded_pact.provider.name).to eq "Mary"
        end

        it "sets the index for each message" do
          expect(loaded_pact.interactions.first.index).to eq 0
        end
      end
    end
  end
end
