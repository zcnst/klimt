# frozen_string_literal: true

# use an environment var to run rspec test suite
ENV['APP_ENV'] = 'rspec'

require 'rspec'
require 'rack/test'

require 'dotenv'
Dotenv.load
ENV['API_KEY'] ||= 'test-api-key-for-specs'

require './app'

RSpec.configure do |config|
  def app
    Sinatra::Application
  end

  config.include Rack::Test::Methods

  # add warnings to the output
  config.warnings = true

  # use rspec-expectations
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # if run a single spec, use more verbose output
  config.default_formatter = 'doc' if config.files_to_run.one?
end
