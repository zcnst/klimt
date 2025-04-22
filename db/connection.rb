# frozen_string_literal: true

puts "load file #{__FILE__}"

# Provides a database connection module for managing PostgreSQL connections
module DBConnection
  class << self
    def get
      if @connection
        puts '✅ Reuse existing db connection!'
        @connection
      else
        puts '✅ New db connection!'
        @connection = connect
      end
    end

    def reset!
      puts '❌ Closing db connection!'
      @connection&.disconnect
      @connection = nil
    end

    private

    def connect
      require 'sequel'

      return setup_test_db if ENV['APP_ENV'] == 'rspec'

      verify_env_variables
      create_postgres_connection
    end

    def verify_env_variables
      required_vars = %w[DB_HOST DB_USER DB_PASSWORD DB_NAME DB_PORT DB_MAX_CONNECTIONS DB_POOL_TIMEOUT]
      missing_vars = required_vars.select { |var| ENV[var].nil? }

      return if missing_vars.empty?

      raise "Environment variables not set: #{missing_vars.join(', ')}"
    end

    def setup_test_db
      db = Sequel.sqlite(':memory:')
      puts '🔌 Executing DB migrations for rspec environment...'
      Sequel.extension :migration
      Sequel::Migrator.run(db, 'db/migrations')
      puts "✅ Migration completed!\n\n"
      db
    end

    def create_postgres_connection
      Sequel.postgres(
        host: ENV.fetch('DB_HOST'),
        user: ENV.fetch('DB_USER'),
        password: ENV.fetch('DB_PASSWORD'),
        database: ENV.fetch('DB_NAME'),
        port: ENV.fetch('DB_PORT'),
        max_connections: ENV.fetch('DB_MAX_CONNECTIONS'),
        pool_timeout: ENV.fetch('DB_POOL_TIMEOUT')
      )
    end
  end
end
