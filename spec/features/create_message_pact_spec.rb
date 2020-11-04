require "pact/message/consumer/rspec"
require "fileutils"
require "pact/helpers"

RSpec.describe "creating a message pact" do

  include Pact::Helpers

  ZOO_PACT_FILE_PATH = "spec/pacts/zoo_consumer-zoo_provider.json"

  before(:all) do
    Pact.message_consumer "Zoo Consumer" do
      has_pact_with "Zoo Provider" do
        builder :alice_producer do
          pact_specification_version '2'
        end
      end

      has_pact_with "Wiffle Provider" do
        builder :wiffle_producer do
          pact_specification_version '2'
        end
      end
    end

    FileUtils.rm_rf ZOO_PACT_FILE_PATH
  end

  class StringMessageHandler
    attr_reader :output_stream

    def initialize
      @output_stream = StringIO.new
    end

    def call(content_string)
      message = OpenStruct.new(JSON.parse(content_string))
      output_stream.print "Hello #{message.name}"
    end
  end

  class HashSymbolMessageHandler
    attr_reader :output_stream

    def initialize
      @output_stream = StringIO.new
    end

    def call(content_hash)
      output_stream.print "Hello #{content_hash[:name]}"
    end
  end

  class HashStringMessageHandler
    attr_reader :output_stream

    def initialize
      @output_stream = StringIO.new
    end

    def call(content_hash)
      output_stream.print "Hello #{content_hash['name']}"
    end
  end

  class ArrayMessageHandler
    attr_reader :output_stream

    def initialize
      @output_stream = StringIO.new
    end

    def call(array)
      output_stream.print "Hello #{array.join(", ")}"
    end
  end

  context "with a string message" do
    let(:message_handler) { StringMessageHandler.new }

    it "allows a consumer to test that it can handle the expected message", pact: :message do
      alice_producer
        .given("there is an alligator named Mary")
        .is_expected_to_send("an alligator message")
        .with_metadata(type: 'animal')
        .with_content(name: "Mary")

      alice_producer.send_message_string do | content_string |
        message_handler.call(content_string)
      end

      expect(message_handler.output_stream.string).to eq ("Hello Mary")
    end
  end

  context "with a hash message with symbol keys" do
    let(:message_handler) { HashSymbolMessageHandler.new }

    it "allows a consumer to test that it can handle the expected message", pact: :message do
      alice_producer
        .given("there is an alligator named John")
        .is_expected_to_send("an alligator message")
        .with_content(name: like("John"))

      alice_producer.send_message_hash do | content_hash |
        message_handler.call(content_hash)
      end

      expect(message_handler.output_stream.string).to eq ("Hello John")
    end
  end

  context "with a hash message with string keys" do
    let(:message_handler) { HashStringMessageHandler.new }

    it "allows a consumer to test that it can handle the expected message", pact: :message do
      alice_producer
        .given("there is an alligator named Sue")
        .is_expected_to_send("an alligator message")
        .with_content("name" => like("Sue"))

      alice_producer.send_message_hash do | content_hash |
        message_handler.call(content_hash)
      end

      expect(message_handler.output_stream.string).to eq ("Hello Sue")
    end
  end

  context "with an array message" do
    let(:message_handler) { ArrayMessageHandler.new }

    it "allows a consumer to test that it can handle the expected message", pact: :message do
      alice_producer
        .given("there is an alligator named John", { some: "params" })
        .and("there is an alligator named Mary")
        .is_expected_to_send("an alligator message")
        .with_content([like("John"), like("Mary")])

      alice_producer.send_message_hash do | content_hash |
        message_handler.call(content_hash)
      end

      expect(message_handler.output_stream.string).to eq ("Hello John, Mary")
    end
  end
end
