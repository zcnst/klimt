# frozen_string_literal: true

puts "load file #{__FILE__}"
Sequel.migration do
  up do
    create_table(:artworks) do
      primary_key :id
      String :title, size: 255

      foreign_key :artist_id, :artists, on_delete: :cascade

      String :medium, size: 128
      String :art_movement, size: 128
      String :year, size: 64
      String :dimensions, size: 64

      String :wikipedia, size: 512
      String :thumbnail, size: 512
      String :full_image, size: 512

      Text :summary
      Text :reference_links
      Text :search_keywords

      Integer :view_count, null: false, default: 0

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      # Ensure one title - artist_id pair per artwork
      unique %i[title artist_id]
    end

    add_index :artworks, %i[title artist_id]
  end

  down do
    drop_table(:artworks)
  end
end
