# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Klimt App' do
  describe 'GET /not-existing-route' do
    it 'should return status 404 KO' do
      get '/not-existing-route'
      expect(last_response).to_not be_ok
      expect(last_response.status).to eq(404)
    end
  end

  describe 'GET /health' do
    it 'should return status 200 OK' do
      get '/health'
      expect(last_response).to be_ok
      expect(last_response.status).to eq(200)
    end

    it 'should return a valid JSON' do
      get '/health'
      expect(last_response.content_type).to eq('application/json')
    end

    it 'should return the expected body' do
      get '/health'
      json_response = JSON.parse(last_response.body)
      expect(json_response['status']).to eq('ok')
      expect(json_response['message']).to eq('Service is running')
    end
  end
end
