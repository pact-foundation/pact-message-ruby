require 'pact/message/consumer_contract_parser'

module Pact
  module Message
    ::RSpec.describe ConsumerContractParser do

      let(:loaded_pact) { ConsumerContract.from_json(string) }

      context "with a Message contract" do
        let(:string) { File.read('spec/fixtures/message-pact-v3-format.json') }

        it "should create a Pact" do
          expect(loaded_pact).to be_instance_of ConsumerContract
        end

        it "should have messages" do
          expect(loaded_pact.interactions).to be_instance_of Array
          expect(loaded_pact.interactions.first).to be_instance_of Pact::ConsumerContract::Message
        end

        it "should have a consumer" do
          expect(loaded_pact.consumer.name).to eq "Bob"
        end

        it "should have a provider" do
          expect(loaded_pact.provider.name).to eq "Mary"
        end
      end
    end
  end
end
