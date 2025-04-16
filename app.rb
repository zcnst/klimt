# frozen_string_literal: true

require 'sinatra'
require_relative 'db/connection'

configure do
  set :database, DBConnection.get
  enable :logging
end

get '/health' do
  content_type :json
  { status: 'ok', message: 'Service is running' }.to_json
end
