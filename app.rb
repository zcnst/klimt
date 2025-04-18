# frozen_string_literal: true

require 'sinatra'
require_relative 'db/connection'

configure do
  set :database, DBConnection.get
  set :api_key, ENV['API_KEY']
end

# public routes

get '/health' do
  content_type :json
  { status: 'ok', message: 'Service is running' }.to_json
end

# admin routes

before '/admin/*' do
  authorize!
end

get '/admin/test' do
  content_type :json
  { message: 'Success! You accessed the protected endpoint', data: [1, 2, 3] }.to_json
end

# helper methods

helpers do
  def valid_api_key?
    auth_header = request.env['HTTP_AUTHORIZATION']

    return false if auth_header.nil? || settings.api_key.nil?

    Rack::Utils.secure_compare(settings.api_key, auth_header)
  end

  def authorize!
    halt 401, { error: 'Unauthorized' }.to_json unless valid_api_key?
  end
end
