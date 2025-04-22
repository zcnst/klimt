# frozen_string_literal: true

puts "load file #{__FILE__}"

require 'sequel'
require_relative 'connection'

puts 'Executing db migrations before starting the app...'

migration_path = File.join(File.dirname(__FILE__), 'migrations')
DB = DBConnection.get

Sequel.extension :migration
begin
  Sequel::Migrator.check_current(DB, migration_path)
  Sequel::Migrator.run(DB, migration_path)
rescue Sequel::Migrator::NotCurrentError
  puts '⚠️ Migrations are not up to date. Running all migrations...'
  Sequel::Migrator.run(DB, migration_path, target: 0)
  Sequel::Migrator.run(DB, migration_path)
ensure
  puts '✅ Migrations completed!'
  DBConnection.reset!
end
