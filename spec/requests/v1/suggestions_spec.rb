# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Suggestions', type: :request do
  describe 'GET /v1/suggestions' do
    let(:params) { { q: 'query' } }

    before do
      get '/v1/suggestions',
          headers: access_token_header,
          params: params
    end

    it 'returns http success' do
      expect(response).to have_http_status(200)
    end

    context 'when params are missing' do
      let(:params) { {} }
      it { expect(response).to have_http_status(422) }
    end
  end
end
