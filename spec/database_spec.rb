# frozen_string_literal: true

require 'spec_helper'

context 'when running RSpec', :db do
  describe 'the Database' do
    it 'uses sequel as ORM' do
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

    it 'is empty' do
      expect(app.database.tables).to be_empty
    end

    describe 'When executing the migrations' do
      before do
        Sequel.extension :migration
        Sequel::Migrator.run(app.database, 'db/migrations')
      end

      it 'contains tables' do
        expect(app.database.tables).not_to be_empty
      end

      it 'contains artworks table' do
        expect(app.database.tables).to include(:artworks)
      end

      it 'contains artist table' do
        expect(app.database.tables).to include(:artists)
      end
    end
  end
end
