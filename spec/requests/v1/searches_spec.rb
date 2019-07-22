# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Search', type: :request do
  describe 'GET /v1/search' do
    let(:params) { { q: 'search_text' } }

    before do
      get '/v1/search',
          headers: access_token_header,
          params: params
    end

    it 'returns http success' do
      expect(response).to have_http_status(200)
    end
  end
end
