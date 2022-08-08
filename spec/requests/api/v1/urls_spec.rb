# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UrlsController, type: :request do
  describe 'Create' do
    let(:original_url) { 'http:://www.test.com' }

    context 'when url is valid' do
      it 'returns http success with the short_url' do
        post api_v1_urls_path, params: { original_url: original_url }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['short_url']).to be_truthy
      end

      it 'creates only one new short_url' do
        expect { post api_v1_urls_path, params: { original_url: original_url } }
          .to change { Url.count }.by(1)
      end
    end

    context 'when url is valid' do
      it 'returns 422 when original_url is invalid' do
        post api_v1_urls_path, params: { original_url: 'invalid' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it 'returns 422 when original_url is missing' do
        post api_v1_urls_path
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create database record' do
        expect { post api_v1_urls_path }.to_not(change { Url.count })
      end
    end
  end

  describe 'redirect' do
    let(:url_object) { create(:url) }

    it 'redirects to the original_url' do
      get "/#{url_object.short_id}"
      expect(response).to have_http_status(307)
      expect(response.location).to eq(url_object.original_url)
    end

    it 'returns not found if the short url is wrong' do
      get '/wrong_short_url'
      expect(response).to have_http_status(:not_found)
    end
  end
end
