# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require 'dotenv'
require './app'

# docs https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  Dotenv.load
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

  #  if run a single spec, use more verbose output
  config.default_formatter = 'doc' if config.files_to_run.one?
end
