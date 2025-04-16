# frozen_string_literal: true

require 'spec_helper'
require 'sequel'
require 'yaml'
require 'erb'

describe 'PostgreSQL Database Connection', :require_db do
  before(:all) do
    # Load database configuration
    config_file = File.join(File.dirname(__FILE__), '..', 'config', 'database.yaml')
    yaml_content = File.read(config_file)
    parsed_yaml = ERB.new(yaml_content).result
    @db_config = YAML.safe_load(parsed_yaml)['postgres']
  end

  it 'should connect to the database successfully' do
    # Create a connection string from the configuration
    connection_string = "postgres://#{@db_config['username']}:#{@db_config['password']}@#{@db_config['host']}:#{@db_config['port']}/#{@db_config['database']}"

    # Attempt to connect to the database
    db = nil
    expect do
      db = Sequel.connect(connection_string)
      db.test_connection # This will raise an error if connection fails
    end.not_to raise_error

    # Additional verification - try executing a simple query
    expect { db.fetch('SELECT 1 as one').first }.not_to raise_error

    # Clean up
    db&.disconnect
  end

  it 'should have the expected database name' do
    expect(@db_config['database']).to eq('klimt_postgres')
  end
end
