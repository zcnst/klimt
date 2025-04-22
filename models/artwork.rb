# frozen_string_literal: true

puts "load file #{__FILE__}"

# Model class for artworks
class Artwork < Sequel::Model
  many_to_one :artist

  plugin :timestamps, update_on_create: true

  def validate
    super
    errors.add(:artist_id, 'does not exist') unless Artist[artist_id]
  end

  def self.create(data)
    raise 'Artwork already exists' if where(title: data['title'], artist_id: data['artist_id']).first

    artwork = new(title: data['title'], artist_id: data['artist_id'])
    update_attributes(artwork, data)
    artwork
  end

  def self.update(data)
    artwork = where(title: data['title'], artist_id: data['artist_id']).first
    raise 'Artwork not found' unless artwork

    update_attributes(artwork, data)
    artwork
  end

  def self.create_or_update(data)
    artwork = where(title: data['title'], artist_id: data['artist_id']).first
    artwork ? update(data) : create(data)
  rescue StandardError => e
    # Handle the error or re-raise it based on your requirements
    puts "Error in create_or_update: #{e.message}"
    raise e
  end

  def self.update_attributes(artwork, data)
    optional_attributes = %w[
      medium dimensions art_movements year wikipedia
      thumbnail full_image summary reference_links
    ]

    optional_attributes.each do |attr|
      artwork[attr.to_sym] = data[attr] if data[attr]
    end

    # search keyword empty for now
    artwork.search_keywords = ''

    artwork.save_changes
    artwork
  end
end
