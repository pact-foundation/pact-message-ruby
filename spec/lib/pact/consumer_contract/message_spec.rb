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

        it "sets the _id" do
          expect(subject._id).to eq "1234"
        end

        context "when the message has a sensibly named metadata instead of metaData (what on earth, Ron?)" do
          before do
            message_hash['metadata'] = message_hash.delete('metaData')
          end

          it "sets the metadata" do
            expect(subject.metadata).to eq "Content-Type" => "application/json"
          end
        end

        context "when there are matching rules" do
          it "correctly locates and parses them" do
            expect(subject.contents.contents["foo"]).to be_a Pact::SomethingLike
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
            message_hash['providerStates'] << { 'name' => 'another state', 'params' => { 'foo' => 'bar' } }
          end

          it "sets the provider state to the first provider state in the array" do
            expect(subject.provider_state).to eq "an alligator named Mary exists"
          end

          it "sets the provider_states as an array" do
            expect(subject.provider_states.size).to eq 2
          end

          it "sets the name and params on each provider state" do
            expect(subject.provider_states.last.name).to eq 'another state'
            expect(subject.provider_states.last.params).to eq 'foo' => 'bar'
          end
        end

        context "when there is a providerState instead of providerStates" do
          before do
            message_hash['providerState'] = message_hash['providerStates'].first['name']
            message_hash.delete('providerStates')
          end

          it "sets the provider_state string" do
            expect(subject.provider_state).to eq "an alligator named Mary exists"
          end

          it "sets the provider_states array to a single item" do
            expect(subject.provider_states.first.name).to eq "an alligator named Mary exists"
          end
        end
      end
    end
  end
end
