# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OAuth::Applications', type: :request do
  describe 'POST /oauth/applications' do
    let(:headers) { xhr_header }

    before do
      post '/oauth/applications',
           headers: headers,
           params: {
             application: {
               name: 'ExampleApp',
               redirect_uri: 'https://example.com/callback',
               scopes: 'activities:read'
             }
           }
    end

    it_behaves_like 'validates xhr'

    it 'returns ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'has web_url' do
      web_url = ENV.fetch('HACKARU_WEB_URL')
      expect(JSON.parse(response.body)['web_url']).to eq web_url
    end
  end
end
