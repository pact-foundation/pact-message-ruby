require 'pact/consumer_contract/message'

module Pact
  ::RSpec.describe ConsumerContract do
    describe Message do
      describe ".from_hash" do
        let(:contract_hash) { JSON.parse(File.read('spec/fixtures/message-pact-v3-format.json')) }
        let(:message_hash) { contract_hash['messages'].first  }
        let(:options) { { pact_specification_version: Pact::SpecificationVersion.new('3.0.0') } }

        subject { Message.from_hash(message_hash, options) }

        it "sets the provider state to the first provider state in the array" do
          expect(subject.provider_state).to eq "an alligator named Mary exists"
        end

        it "sets the metadata" do
          expect(subject.metadata).to eq "Content-Type" => "application/json"
        end

        context "when there are matching rules" do
          it "correctly locates and parses them" do
            expect(subject.content.content["foo"]).to be_a Pact::SomethingLike
          end
        end

        context "when there is an empty array of provider states" do
          before do
            message_hash['providerStates'] = []
          end
          it "sets the provider state to nil" do
            expect(subject.provider_state).to be nil
          end
        end

        context "when there is more than one provider state" do
          before do
            message_hash['providerStates'] << { 'name' => 'another state'}
            message_hash['providerStates'] << { 'name' => 'yet another state'}
            allow(Pact.configuration.error_stream).to receive(:puts)
          end

          let(:expected_warning) { 'WARN: Using only the first provider state, "an alligator named Mary exists", as support for multiple provider states is not yet implemented. Ignoring provider states: "another state", "yet another state"' }

          it "sets the provider state to the first provider state in the array" do
            expect(subject.provider_state).to eq "an alligator named Mary exists"
          end

          it "logs a warning because multiple states is not supported yet" do
            expect(Pact.configuration.error_stream).to receive(:puts).with(expected_warning)
            subject
          end
        end

        context "when there are params used" do
          before do
            message_hash['providerStates'] << { 'name' => 'another state', 'params' => {}}
            message_hash['providerStates'] << { 'name' => 'yet another state', 'params' => {'foo' => 'bar'}}
            allow(Pact.configuration.error_stream).to receive(:puts)
          end

          let(:expected_warning) { "WARN: Ignoring params for the following provider states as params support is not yet implemented: \"yet another state\"" }
          it "logs a warning because params are not supported yet" do
            expect(Pact.configuration.error_stream).to receive(:puts).with(expected_warning)
            subject
          end
        end
      end
    end
  end
end
