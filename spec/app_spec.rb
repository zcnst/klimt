# frozen_string_literal: true

require 'spec_helper'

context 'when the App is running' do
  describe 'GET /not-existing-route' do
    it 'returns status 404 KO' do
      get '/not-existing-route'
      expect(last_response).not_to be_ok
      expect(last_response.status).to eq(404)
    end
  end

  describe 'GET /health' do
    it 'returns status 200 OK' do
      get '/health'
      expect(last_response).to be_ok
      expect(last_response.status).to eq(200)
    end

    it 'returns a valid JSON' do
      get '/health'
      expect(last_response.content_type).to eq('application/json')
    end

    it 'returns the expected body' do
      get '/health'
      json_response = JSON.parse(last_response.body)
      expect(json_response['status']).to eq('ok')
      expect(json_response['message']).to eq('Service is running')
    end
  end

  describe 'GET /admin/test' do
    context 'with auth not set' do
      it 'returns status 401 KO' do
        get '/admin/test'
        expect(last_response).not_to be_ok
        expect(last_response.status).to eq(401)
      end
    end

    context 'with invalid auth' do
      it 'returns status 401 KO' do
        get '/admin/test', nil, { 'HTTP_AUTHORIZATION' => 'invalid_key' }
        expect(last_response).not_to be_ok
        expect(last_response.status).to eq(401)
      end
    end

    context 'with valid auth' do
      it 'returns status 200 OK' do
        headers = { 'HTTP_AUTHORIZATION' => ENV['API_KEY'] }
        get '/admin/test', nil, headers

        expect(last_response).to be_ok
        expect(last_response.status).to eq(200)
      end
    end
  end
end
