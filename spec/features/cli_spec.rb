# frozen_string_literal: true

require 'fileutils'
require 'English'

RSpec.describe 'the CLI' do
  CLI_SPEC_PACT_FILE_PATH = './tmp/foo-bar.json'.freeze

  let(:json) { File.read('spec/fixtures/message-v1-format.json') }
  let(:command) { 'bundle exec bin/pact-message help' }

  RSpec.shared_examples 'terminate successully to create pact file' do
    before do
      FileUtils.rm_rf CLI_SPEC_PACT_FILE_PATH
      `#{command}`
    end

    it { expect($CHILD_STATUS).to be_success }

    it 'is expected to create a pact file' do
      expect(File).to exist(CLI_SPEC_PACT_FILE_PATH)
    end
  end

  context 'when providing a message' do
    let(:command) { "bundle exec bin/pact-message update '#{json}' --consumer Foo --provider Bar --pact-dir ./tmp" }

    include_examples 'terminate successully to create pact file'
  end

  context 'when piping the message from standard input' do
    let(:command) { "echo '#{json}' | bundle exec bin/pact-message update --consumer Foo --provider Bar --pact-dir ./tmp" }

    include_examples 'terminate successully to create pact file'
  end

  context 'when piping the message from standard input with a dash' do
    let(:command) { "echo '#{json}' | bundle exec bin/pact-message update - --consumer Foo --provider Bar --pact-dir ./tmp" }

    include_examples 'terminate successully to create pact file'
  end
end
