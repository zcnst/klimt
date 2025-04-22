# frozen_string_literal: true

puts "load file #{__FILE__}"
require_relative '../models/artist'
require_relative '../models/artwork'

# DataLoader handles the creation and updating of Artist and Artwork records from JSON data.
# It validates the input data before processing and provides
# a consistent interface for data loading operations.
class DataLoader
  def self.load_artist(data)
    new(data).process do |loader|
      model_class = Artist
      is_valid = loader.instance_eval { @data['name'] && !@data['name'].empty? }
      [model_class, is_valid, 'artist']
    end
  end

  def self.load_artwork(data)
    new(data).process do |loader|
      puts "processing artwork with data: #{loader.data}"
      is_valid = loader.instance_eval do
        @data['title'] && !@data['title'].empty? &&
          @data['artist'] && !@data['artist'].empty? && Artist.exists?(@data['artist'])
      end
      [model_class, is_valid, 'artwork']
    end
  end

  def initialize(data)
    @data = data # at this point, data is a valid json
  end

  # attr_reader :data

  def process
    model_class, is_valid, entity_type = yield(self)

    if is_valid
      { data: model_class.create_or_update(@data).values.to_json }
    else
      { error: "Invalid #{entity_type} data" }
    end
  rescue StandardError => e
    { error: e.message }
  end
end
