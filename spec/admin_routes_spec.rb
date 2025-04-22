# frozen_string_literal: true

puts "load file #{__FILE__}"
require 'spec_helper'
require 'shared_examples_for_routes'

describe 'Testing the Admin routes' do
  let(:valid_auth_headers) do
    {
      'HTTP_AUTHORIZATION' => ENV.fetch('API_KEY', nil),
      'CONTENT_TYPE' => 'application/json'
    }
  end

  let(:invalid_auth_headers) do
    {
      'HTTP_AUTHORIZATION' => 'invalid_key',
      'CONTENT_TYPE' => 'application/json'
    }
  end

  let(:response_body) { JSON.parse(last_response.body) }

  describe 'GET /admin/test' do
    context 'with auth headers not set' do
      before { get '/admin/test' }

      it_behaves_like 'unauthorized call'
    end

    context 'with invalid auth headers' do
      before { get '/admin/test', nil, invalid_auth_headers }

      it_behaves_like 'unauthorized call'
    end

    context 'with valid auth headers' do
      before do
        get '/admin/test', nil, valid_auth_headers
      end

      it_behaves_like 'successful GET call', 'You accessed the protected endpoint'

      it 'returns body with data: [1, 2, 3]' do
        expect(response_body['data']).to eq([1, 2, 3])
      end
    end
  end

  describe 'POST /admin/load/artist' do
    context 'with invalid auth headers' do
      before do
        post '/admin/load/artist', nil, invalid_auth_headers
      end

      it_behaves_like 'unauthorized call'
    end

    context 'with valid auth headers' do
      context 'when providing valid artist data' do
        before do
          body = {
            name: Faker::Name.name
          }.to_json
          post '/admin/load/artist', body, valid_auth_headers
        end

        it_behaves_like 'successful POST call', 'Artist created successfully'

        it 'returns body with the created artist' do
          expect(response_body['artist']).to be_a(Hash)
        end
      end

      context 'when providing invalid artist data' do
        before do
          invalid_body = {
            title: Faker::Name.name
          }.to_json
          post '/admin/load/artist', invalid_body, valid_auth_headers
        end

        it 'returns a json' do
          expect(last_response.content_type).to eq('application/json')
        end

        it 'returns status 422' do
          expect(last_response).not_to be_created
          expect(last_response.status).to eq(422)
        end

        it 'returns body with error "Invalid artist data"' do
          expect(response_body['error']).to eq('Invalid artist data')
        end

        it 'returns body with message "Failed to create artist"' do
          expect(response_body['message']).to eq('Failed to create artist')
        end
      end

      context 'when database fails to save the artist' do
        let(:valid_body) do
          {
            name: Faker::Name.name
          }.to_json
        end

        before do
          # Allow Artist.create_or_update to be called normally but raise an exception
          allow(Artist).to receive(:create_or_update).and_raise(Sequel::DatabaseError.new('Database error'))
          post '/admin/load/artist', valid_body, valid_auth_headers
        end

        it 'returns a json' do
          expect(last_response.content_type).to eq('application/json')
        end

        it 'returns status 422' do
          expect(last_response).not_to be_created
          expect(last_response.status).to eq(422)
        end

        it 'returns body with error "Database error"' do
          expect(response_body['error']).to include('Database error')
        end

        it 'returns body with message "Failed to create artist"' do
          expect(response_body['message']).to eq('Failed to create artist')
        end
      end
    end
  end
end
