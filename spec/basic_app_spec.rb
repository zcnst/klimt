# frozen_string_literal: true

puts "load file #{__FILE__}"
require 'spec_helper'
require 'shared_examples_for_routes'

describe 'Basic tests for app routes' do
  describe 'GET /health' do
    before { get '/health' }

    it_behaves_like 'successful GET call', 'Service is running'
  end

  describe 'GET /not-existing-route' do
    let(:response_body) { JSON.parse(last_response.body) }

    before { get '/not-existing-route' }

    it 'returns a not found status' do
      expect(last_response).not_to be_ok
      expect(last_response.status).to eq(404)
    end

    it 'returns body with appropriate message: false' do
      expect(response_body['message']).to eq('Not Found')
    end

    it 'returns a valid JSON response' do
      expect { response_body }.not_to raise_error
    end
  end
end
