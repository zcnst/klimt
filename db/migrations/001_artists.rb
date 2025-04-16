# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:artists) do
      primary_key :id
      String :name, null: false, size: 255

      String :born, size: 128
      String :died, size: 128
      String :art_movement, size: 128

      String :wikipedia_url, size: 512
      String :thumbnail_url, size: 512
      String :portrait_url, size: 512

      Text :summary
      Text :search_keywords
      Text :other_names

      Integer :view_count, null: false, default: 0

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      unique %i[name other_names]
    end

    add_index :artists, :name, concurrently: true
  end

  down do
    drop_table(:artists)
  end
end
