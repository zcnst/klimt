# frozen_string_literal: true

require 'sequel'
require_relative 'connection'

migration_path = File.join(File.dirname(__FILE__), 'migrations')
database = DBConnection.get

Sequel.extension :migration

begin
  Sequel::Migrator.check_current(database, migration_path)
  Sequel::Migrator.run(database, migration_path)
rescue Sequel::Migrator::NotCurrentError
  Sequel::Migrator.run(database, migration_path, target: 0)
  Sequel::Migrator.run(database, migration_path)
end
