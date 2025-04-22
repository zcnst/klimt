# frozen_string_literal: true

puts "load file #{__FILE__}"
require 'spec_helper'

describe 'the database' do
  context 'when running the `rspec` suite' do
    it 'uses Sequel as ORM' do
      expect(app.database).to be_a(Sequel::Database)
    end

    it 'is an in-memory database' do
      expect(app.database.opts[:database]).to eq(':memory:')
    end

    it 'is connected' do
      expect(app.database.test_connection).to be(true)
    end

    it 'uses sqlite as adapter' do
      expect(app.database.opts[:adapter]).to eq(:sqlite)
    end
  end

  context 'when migrations are executed' do
    it 'contains artworks table' do
      expect(app.database.tables).to include(:artworks)
    end

    it 'contains artist table' do
      expect(app.database.tables).to include(:artists)
    end
  end
end
