require "pact/message/consumer/rspec"
require "fileutils"
require "ostruct"

RSpec.describe "creating a message pact with a failure" do

  FOO_BAR_PACT_FILE_PATH = "spec/pacts/foo_consumer-bar_producer.json"

  before(:all) do
    Pact.message_consumer "Foo Consumer" do
      has_pact_with "Bar Producer" do
        mock_provider :bar_producer do
          pact_specification_version '2'
        end
      end
    end

    FileUtils.rm_rf FOO_BAR_PACT_FILE_PATH
  end

  class MessageHandler

    attr_reader :output_stream

    def initialize
      @output_stream = StringIO.new
    end

    def call(content_string)
      message = OpenStruct.new(JSON.parse(content_string))
      output_stream.print "Hello #{message.name}"
    end
  end

  let(:message_handler) { MessageHandler.new }

  it "allows a consumer to test that it can handle a message example correctly", pact: :message do
    bar_producer
      .given("there is an alligator named Mary")
      .is_expected_to_send("an alligator message")
      .with_metadata(type: 'animal')
      .with_content(name: "Mary")

    bar_producer.send_message_string do | content_string |
      message_handler.call(content_string)
    end

    expect(message_handler.output_stream.string).to eq ("Hello The Wrong Name")
  end
end
