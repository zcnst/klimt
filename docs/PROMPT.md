# Prompt 🤖

## General Instructions

### 🛑 IMPORTANT: ALWAYS ask for explicit permission before
- Creating artifacts
- Generating code blocks of any size
- Writing implementation solutions
- Proceeding to the next step of a solution

In general:
- Work iteratively, breaking down complex tasks into manageable steps.
- Provide one solution option at a time and wait for feedback before proceeding to the next step.

### 📋 Code and Artifact Format Requirements
- All code MUST be presented in standard markdown code blocks with language tags (e.g., ```ruby, ```sql)  
- Artifacts must be easy to copy and paste - avoid special formatting that hinders copy/paste functionality
- Always use code blocks for any code snippets, configuration files, or command examples
- For multi-file solutions, clearly label each file with its path and name before the code block

## Project Scope

* Web application called "klimt" serving as a museum guide for artwork search
* Frontend will be created using Lovable.dev (not part of this work)
* Backend should be minimalistic and built with Ruby using Sinatra
* Fast artwork search API with autocomplete functionality
* Initial seed of 100 paintings
* Painting detail pages with images and LLM-generated descriptions
* Artist detail pages with portraits and LLM-generated descriptions
* Description storage in PostgreSQL (generate once, retrieve afterward)
* Paginated listing of paintings by artist
* Docker containerization (required)
* AWS deployment for MVP
* GitHub and GitHub Codespaces for development

## User Flow Requirements

* Primary Search Flow:
  - User navigates to the application
  - User begins typing artwork title in search field
  - Application displays autocomplete results in real-time
  - Results show thumbnail images and basic artwork information
  - User selects desired artwork from search results
  - Artwork detail page loads showing:
    - High-resolution image of the artwork
    - Artwork title and creation date
    - LLM-generated description (retrieved from DB if exists)
    - Artist name with link to artist page
    - Additional artwork metadata (medium, dimensions, etc.)

* Artist Flow:
  - User can search directly for an artist name
  - User can navigate to artist page from artwork detail
  - Artist detail page shows:
    - Artist portrait/photograph
    - LLM-generated artist biography (retrieved from DB if exists)
    - Paginated gallery of the artist's works
    - "Load more" functionality for artists with many works

* Backend Processing:
  - First request for artwork/artist description triggers LLM generation
  - Generated descriptions stored directly in PostgreSQL database
  - No separate caching system (Redis, etc.) needed for MVP
  - Subsequent requests simply query the database for existing descriptions
  - Search queries optimized for fast autocomplete response times
  - API endpoints deliver minimal payload for initial searches
  - Detailed information loaded only when specific artwork/artist selected

* Future flow
   - User starts typing in search box
   - Fast autocomplete shows matching artworks and artists
   - User selects an item:
     - If artwork: Shows artwork with basic info (level 0)
     - If not yet generated, calls LLM to create description
     - If artist: Shows artist with basic info (level 0)
     - If not yet generated, calls LLM to create description
   - User can press "Learn More" button up to 3 times:
     - System checks if the next level description exists
     - If it exists, displays immediately
     - If not, generates it using LLM, stores it, then displays
   - Every view increments the view_count counter

## Stack

* Backend: Ruby with Sinatra
* Database: PostgreSQL 
* Web Server: Puma
* ORM: Sequel
* Testing: RSpec
* Configuration: Dotenv
* Containerization: Docker
* Deployment: AWS