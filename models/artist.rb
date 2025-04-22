# frozen_string_literal: true

puts "load file #{__FILE__}"

# Model class for artists
class Artist < Sequel::Model
  one_to_many :artworks

  plugin :timestamps, update_on_create: true

  # Check if artist exists - for now just use the name
  def self.exists?(name)
    !where(name: name).empty?
  end

  # Find artist - to be improved, for now just use the name
  def self.find(name)
    artist = where(name: name)
    return nil if artist.empty?

    puts '⚠️ Warning, more than one artist found - returning the first...' if artist.count > 1

    # Return the first row
    artist.first
  end

  def self.create(data)
    raise "Artist already exists: #{data['name']}" if exists?(data['name'])

    artist = new(name: data['name'])
    update_attributes(artist, data)
    artist
  end

  def self.update(data)
    artist = find(data['name'])
    raise "Artist not found: #{data['name']}" unless artist

    update_attributes(artist, data)
    artist
  end

  def self.create_or_update(data)
    artist = find(data['name'])
    artist ? update(data) : create(data)
  rescue StandardError => e
    puts "Error in create_or_update: #{e.message}"
    raise e
  end

  def self.update_attributes(artist, data)
    optional_attributes = %w[
      birth death nationality wikipedia thumbnail
      portrait summary other_names reference_links
    ]

    optional_attributes.each do |attr|
      artist[attr.to_sym] = data[attr] if data[attr]
    end

    # search keyword empty for now
    artist.search_keywords = ''

    artist.save_changes
    artist
  end
end
