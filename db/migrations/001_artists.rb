# frozen_string_literal: true

puts "load file #{__FILE__}"
Sequel.migration do
  up do
    create_table(:artists) do
      primary_key :id

      String :name, null: false, size: 255
      String :birth, size: 128
      String :death, size: 128
      String :nationality, size: 128

      String :wikipedia, size: 512
      String :thumbnail, size: 512
      String :portrait, size: 512

      Text :summary
      Text :other_names
      Text :reference_links
      Text :search_keywords

      Integer :view_count, null: false, default: 0

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      unique %i[name other_names]
    end

    add_index :artists, :name
  end

  down do
    drop_table(:artists)
  end
end
