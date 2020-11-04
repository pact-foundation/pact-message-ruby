require "rspec/core/rake_task"

ZOO_PACT_FILE_PATH = "spec/pacts/zoo_consumer-zoo_provider.json"

RSpec::Core::RakeTask.new(:pass) do | task |
  task.pattern = "spec/features/create_message_pact_spec.rb"
end

RSpec::Core::RakeTask.new(:fail) do | task |
  task.pattern = "spec/features/create_message_pact_with_failure_test.rb"
end

task :pass_writes_pact_file do
  require 'json'
  puts "Ensuring that pact file is written for successful test suites"
  FileUtils.rm_rf(ZOO_PACT_FILE_PATH)
  Rake::Task['pass'].execute
  if !File.exist?(ZOO_PACT_FILE_PATH)
    raise "Expected pact file to be written at #{ZOO_PACT_FILE_PATH}"
  end

  pact_hash = JSON.parse(File.read(ZOO_PACT_FILE_PATH))
  if pact_hash['messages'].size < 2
    raise "Expected pact file to contain more than 1 message"
  end
end

task :fail_does_not_write_pact_file do
  puts "Ensuring that pact file is NOT written for failed test suites"
  FileUtils.rm_rf(ZOO_PACT_FILE_PATH)
  expect_to_fail('bundle exec rake fail')
  if File.exist?(ZOO_PACT_FILE_PATH)
    raise "Expected pact file NOT to be written at #{ZOO_PACT_FILE_PATH}"
  end
end

task :default => [:pass_writes_pact_file, :fail_does_not_write_pact_file]

def expect_to_fail command, options = {}
  success = execute_command command, options
  fail "Expected '#{command}' to fail" if success
end

def execute_command command, options
  require 'open3'
  result = nil
  Open3.popen3(command) {|stdin, stdout, stderr, wait_thr|
    result = wait_thr.value
    ensure_patterns_present(command, options, stdout, stderr) if options[:with]
  }
  result.success?
end

def ensure_patterns_present command, options, stdout, stderr
  require 'term/ansicolor'
  output = stdout.read + stderr.read
  options[:with].each do | pattern |
    raise (::Term::ANSIColor.red("Could not find #{pattern.inspect} in output of #{command}") + "\n\n#{output}") unless output =~ pattern
  end
end
