require 'fileutils'

RSpec.describe "the CLI" do
  CLI_SPEC_PACT_FILE_PATH = "./tmp/foo-bar.json"

  before do
    FileUtils.rm_rf CLI_SPEC_PACT_FILE_PATH
  end

  let(:json) { File.read('spec/fixtures/message-v1-format.json') }

  it "creates a pact file with the given message" do
    output = `bundle exec bin/pact-message update '#{json}' --consumer Foo --provider Bar --pact-dir ./tmp`
    exit_status = $?
    puts output if exit_status != 0
    expect(exit_status).to eq 0
    expect(File.exist?(CLI_SPEC_PACT_FILE_PATH)).to be true
  end

  it "creates a pact file with a message from the standard input" do
    output = `echo '#{json}' | bundle exec bin/pact-message update --consumer Foo --provider Bar --pact-dir ./tmp`
    exit_status = $?
    puts output if exit_status != 0
    expect(exit_status).to eq 0
    expect(File.exist?(CLI_SPEC_PACT_FILE_PATH)).to be true
  end
end
