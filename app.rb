require 'sinatra'

get '/health' do
  content_type :json
  { status: 'ok', message: 'Service is running' }.to_json
end