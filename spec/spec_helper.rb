require "bundler/setup"
require "pact/message"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"

  config.disable_monkey_patching!
  is_windows = Gem.win_platform?

  config.filter_run_excluding :skip_windows => is_windows
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
