# frozen_string_literal: true

# PostgreSQL-specific extensions and indexes only if using PostgreSQL
Sequel.migration do
  up do
    if adapter_scheme == :postgresql
      run('CREATE EXTENSION IF NOT EXISTS pg_trgm;')
      run('CREATE INDEX idx_artist_keywords_trgm ON artists USING gin (search_keywords gin_trgm_ops);')
      run('CREATE INDEX idx_artworks_keywords_trgm ON artworks USING gin (search_keywords gin_trgm_ops);')
    end
  end

  down do
    if adapter_scheme == :postgresql
      run('DROP INDEX IF EXISTS idx_artist_keywords_trgm;')
      run('DROP INDEX IF EXISTS idx_artworks_keywords_trgm;')
      run('DROP EXTENSION IF EXISTS pg_trgm;')
    end
  end
end
