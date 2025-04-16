# Klimt Database Setup 🎨

## 🐘 Development PostgreSQL

```zsh
# Start database
docker compose up -d

# Stop database
docker compose down
```

## 🧪 Connection Verification

```zsh
# Verify database connection
bundle exec rspec spec/db_connection_spec.rb
```

## 📋 Connection Details for Adminer

| Parameter | Value |
|-----------|-------|
| System    | PostgreSQL |
| Server    | db |
| Username  | DB_USER |
| Password  | DB_PASSWORD |
| Database  | DB_NAME |

## 📐 Database Schema

_Coming soon. Schema details will be added as the project progresses._

# Klimt Museum Guide Database Design

## Project Overview
- Project name: klimt
- Audio guide web application for art museums
- Backend: Minimalistic Ruby using Sinatra
- Database: PostgreSQL
- Fast artwork search API with autocomplete
- Docker containerization
- AWS deployment for MVP
- GitHub and GitHub Codespaces for development

## Database Schema

### 1. search_entries Table
Primary table for fast search functionality:

```sql
CREATE TABLE search_entries (
  id SERIAL PRIMARY KEY,
  entity_type VARCHAR(10) NOT NULL CHECK (entity_type IN ('artwork', 'artist')),
  title VARCHAR(255), -- Artwork title (required for artworks, NULL for artists)
  artist_name VARCHAR(255), -- Artist name (required for artworks AND for artists)
  thumbnail_url VARCHAR(512), --optional, default if not passed to a placehoder url
  search_keywords TEXT, -- Optimized for fast autocompletion
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  -- Ensure required fields based on entity_type
  CONSTRAINT valid_entry_fields CHECK (
    (entity_type = 'artwork' AND title IS NOT NULL AND artist_name IS NOT NULL) OR
    (entity_type = 'artist' AND artist_name IS NOT NULL)
  )
);

-- Indexes for fast searching
CREATE INDEX idx_search_entries_entity_type ON search_entries(entity_type);
CREATE INDEX idx_search_entries_title ON search_entries(title);
CREATE INDEX idx_search_entries_artist_name ON search_entries(artist_name);

-- Full text search capability
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX idx_search_entries_keywords_trgm ON search_entries USING gin (search_keywords gin_trgm_ops);
```

### 2. artworks Table
Contains detailed information about artworks with multiple description levels:

```sql
CREATE TABLE artworks (
  id SERIAL PRIMARY KEY,
  artwork_id INTEGER NOT NULL REFERENCES search_entries(id),
  description_level INTEGER NOT NULL CHECK (description_level BETWEEN 0 AND 3),
  description_content TEXT,
  medium VARCHAR(128), -- E.g., "Oil on canvas", "Sculpture"
  art_movement VARCHAR(128), -- E.g., "Impressionism", "Cubism"
  full_image_url VARCHAR(512),
  year VARCHAR(64),
  audio_url VARCHAR(512), -- For future S3 storage
  view_count INTEGER NOT NULL DEFAULT 0, -- Counter for page views
  generated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  -- Ensure one description level per artwork
  UNIQUE(artwork_id, description_level)
);

CREATE INDEX idx_artworks_artwork_id ON artworks(artwork_id);
```

### 3. artists Table
Contains detailed information about artists with multiple description levels:

```sql
CREATE TABLE artists (
  id SERIAL PRIMARY KEY,
  artist_name VARCHAR(255) NOT NULL,
  description_level INTEGER NOT NULL CHECK (description_level BETWEEN 0 AND 3),
  description_content TEXT,
  portrait_url VARCHAR(512),
  audio_url VARCHAR(512), -- For future S3 storage
  years_active VARCHAR(64),
  view_count INTEGER NOT NULL DEFAULT 0, -- Counter for page views
  generated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  -- Ensure one description level per artist
  UNIQUE(artist_name, description_level)
);

CREATE INDEX idx_artists_artist_name ON artists(artist_name);
```

## Implementation Details

### Initial Data Loading
1. Manually populate only the `search_entries` table with:
   - For artworks: entity_type, title, artist_name
   - For artists: entity_type, artist_name
   - Use a placeholder URL for thumbnail_url until real images are available
   
2. Automatically after inserting a new search entry:
   - Create empty records in `artworks` or `artists` with description_level=0
   - Only populate linking fields (artwork_id or artist_name)
   - Automatically generate search_keywords based on existing fields
   - Leave description_content and other fields empty

3. LLM content generation:
   - Only trigger LLM calls when a user requests an artwork/artist via API
   - If description_content is empty, generate it with LLM and save
   - No LLM calls during initial database seeding

### Search Functionality
- Unified search across both artworks and artists
- Fast autocomplete functionality as user types
- Returns both artwork and artist matches with entity type differentiation
- Optimized with GIN indexes and trigram matching for partial word searches

### Description Levels
- Level 0: Basic information (default, ~1 minute read)
- Level 1, 2, 3: Progressive additional details without repetition
- Each level is generated by LLM only when first requested
- Future support for audio narration of each description level

### User Flow
1. User starts typing in search box
2. Fast autocomplete shows matching artworks and artists
3. User selects an item:
   - If artwork: Shows artwork with basic info (level 0)
   - If not yet generated, calls LLM to create description
   - If artist: Shows artist with basic info (level 0)
   - If not yet generated, calls LLM to create description
4. User can press "Learn More" button up to 3 times:
   - System checks if the next level description exists
   - If it exists, displays immediately
   - If not, generates it using LLM, stores it, then displays
5. Every view increments the view_count counter

### Database Optimization
- Separate search table for minimal bandwidth usage on autocomplete
- Strategic indexes for common query patterns
- Full-text search capabilities with trigram matching

### Future Features
- Audio narration stored in S3
- Text-to-speech functionality for dynamic guide narration