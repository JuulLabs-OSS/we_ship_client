require 'bundler/setup'
require 'dotenv/load'
require 'we_ship_client'

require 'stub_env'
require 'webmock'
require 'vcr'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include StubEnv::Helpers
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.filter_sensitive_data('<WE_SHIP_USERNAME>') { ENV['WE_SHIP_USERNAME'] }
  config.filter_sensitive_data('<WE_SHIP_PASSWORD>') { ENV['WE_SHIP_PASSWORD'] }
  config.filter_sensitive_data('<WE_SHIP_BASE_URL>') { ENV['WE_SHIP_BASE_URL'] }
  config.filter_sensitive_data('<WE_SHIP_CUSTOMER_CODE>') { ENV['WE_SHIP_CUSTOMER_CODE'] }
  config.hook_into :webmock
end
