# frozen_string_literal: true

puts "load file #{__FILE__}"
require 'spec_helper'

RSpec.shared_examples 'successful GET call' do |message|
  let(:response_body) { JSON.parse(last_response.body) }

  it 'is successful' do
    expect(last_response).to be_ok
  end

  it 'returns status 200' do
    expect(last_response.status).to eq(200)
  end

  it 'returns body with no error' do
    expect(response_body['error']).to be_nil
  end

  it 'returns body with appropriate message' do
    expect(response_body['message']).to eq(message)
  end

  it 'returns a valid JSON content type' do
    expect(last_response.content_type).to eq('application/json')
  end
end

RSpec.shared_examples 'successful POST call' do |message|
  let(:response_body) { JSON.parse(last_response.body) }

  it 'is successful' do
    expect(last_response).to be_created
  end

  it 'returns status 201' do
    expect(last_response.status).to eq(201)
  end

  it 'returns body with no error' do
    expect(response_body['error']).to be_nil
  end

  it 'returns body with appropriate message' do
    expect(response_body['message']).to eq(message)
  end
end

RSpec.shared_examples 'unauthorized call' do |_message|
  let(:response_body) { JSON.parse(last_response.body) }

  it 'is not successful' do
    expect(last_response).not_to be_ok
  end

  it 'returns status 401' do
    expect(last_response.status).to eq(401)
  end

  it 'returns body with error "Invalid credentials"' do
    expect(response_body['error']).to eq('Invalid credentials')
  end

  it 'returns body with appropriate message "Unauthorized"' do
    expect(response_body['message']).to eq('Unauthorized')
  end
end
