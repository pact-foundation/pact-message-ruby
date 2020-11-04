require "pact/message/consumer/rspec"
require "fileutils"

RSpec.describe "creating a message pact with a failure" do
  before(:all) do
    Pact.message_consumer "Foo Consumer 2" do
      has_pact_with "Bar Producer 2" do
        builder :bar_producer_2 do
          pact_specification_version '2'
        end
      end
    end
  end

  let(:message_handler) { MessageHandler.new }

  it "raises an error when the message is not yielded", pact: :message, pending: "this is meant to fail as the message was not yielded" do
    bar_producer_2
      .given("there is an alligator named Mary")
      .is_expected_to_send("an alligator message")
      .with_metadata(type: 'animal')
      .with_content(name: "Mary")
  end

  it "raises an error when the send_message_string is called and no message has been defined", pact: :message, pending: "this is meant to fail" do
    bar_producer_2.send_message_string do | message |

    end
  end
end
