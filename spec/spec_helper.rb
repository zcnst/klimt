# frozen_string_literal: true

puts "load file #{__FILE__}"
# use an environment var to run rspec test suite
require 'dotenv'
require 'rspec'
require 'rack/test'
require 'faker'

Dotenv.load
ENV['APP_ENV'] = 'rspec'
ENV['API_KEY'] ||= 'test-api-key-for-specs'

require './app'

RSpec.configure do |config|
  def app
    Sinatra::Application
  end

  config.include Rack::Test::Methods

  config.warnings = true
  config.formatter = :documentation

  # use rspec-expectations
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.after(:suite) do
    DBConnection.reset!
  end
end
