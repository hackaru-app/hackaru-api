# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::OAuth::Applications', type: :request do
  describe 'POST /v1/oauth/applications' do
    before do
      post '/v1/oauth/applications',
           params: {
             application: {
               name: 'ExampleApp',
               redirect_uri: 'https://example.com/callback',
               scopes: 'activities:read'
             }
           }
    end

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end

    it 'has web_url' do
      web_url = ENV.fetch('HACKARU_WEB_URL')
      expect(JSON.parse(response.body)['web_url']).to eq web_url
    end
  end
end
