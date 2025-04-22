# frozen_string_literal: true

puts "load file #{__FILE__}"
require 'sinatra'
require 'sinatra/json'

# internal dependencies
require_relative 'db/connection'
configure do
  puts '✅ Configuring Sinatra application...'
  set :database, DBConnection.get
  set :api_key, ENV.fetch('API_KEY', nil)
end

require_relative 'services/data_loader'
require_relative 'models/artist'
require_relative 'models/artwork'

# public routes

get '/health' do
  json message: 'Service is running'
end

# admin routes

before '/admin/*' do
  authorize!
end

get '/admin/test' do
  json message: 'You accessed the protected endpoint', data: [1, 2, 3]
end

post '/admin/load/artwork' do
  data = parse_request_json(request.body.read)
  result = DataLoader.load_artwork(data)

  if result[:error]
    status 422
    json message: 'Failed to create artwork', error: result[:error]
  else
    status 201
    json message: 'Artwork created successfully', artwork: data
  end
end

post '/admin/load/artist' do
  data = parse_request_json(request.body.read)
  result = DataLoader.load_artist(data)
  if result[:error]
    status 422
    json message: 'Failed to create artist', error: result[:error]
  else
    status 201
    json message: 'Artist created successfully', artist: data
  end
end

not_found do
  status 404
  json message: 'Not Found'
end

# helper methods, to move into a module if it's growing to much
helpers do
  def authorize!
    return if valid_api_key?

    halt 401, json(message: 'Unauthorized', error: 'Invalid credentials')
  end

  def parse_request_json(data)
    if data.empty?
      halt 400, json(message: 'Invalid request', error: 'Request body is empty')
    else
      JSON.parse(data)
    end
  rescue JSON::ParserError
    halt 418, json('Invalid request', error: 'Request body is not a valid JSON')
  end

  def valid_api_key?
    auth_header = request.env['HTTP_AUTHORIZATION']
    return false if auth_header.nil? || settings.api_key.nil?

    Rack::Utils.secure_compare(settings.api_key, auth_header)
  end
end
