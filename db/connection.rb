# frozen_string_literal: true

# Provides a database connection module for managing PostgreSQL connections
module DBConnection
  class << self
    def get
      @get ||= connect
    end

    def reset!
      @connection = nil
    end

    # rubocop :disable Metrics/MethodLength
    def connect
      require 'sequel'

      return Sequel.sqlite(':memory:') if ENV['APP_ENV'] == 'rspec'

      %w[DB_HOST DB_USER DB_PASSWORD DB_NAME DB_PORT DB_MAX_CONNECTIONS DB_POOL_TIMEOUT].each do |var|
        raise "Environment variable #{var} is not set" unless ENV[var]
      end

      Sequel.postgres(
        host: ENV['DB_HOST'],
        user: ENV['DB_USER'],
        password: ENV['DB_PASSWORD'],
        database: ENV['DB_NAME'],
        port: ENV['DB_PORT'],
        max_connections: ENV['DB_MAX_CONNECTIONS'],
        pool_timeout: ENV['DB_POOL_TIMEOUT']
      )
    end
    # rubocop:enable Metrics/MethodLength

    private :connect
  end
end
