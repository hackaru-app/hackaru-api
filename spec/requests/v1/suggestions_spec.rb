# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Suggestions', type: :request do
  describe 'GET /v1/suggestions' do
    let(:headers) { xhr_header }
    let(:params) { { q: 'query', limit: 10 } }

    before do
      login
      get '/v1/suggestions',
          headers: headers,
          params: params
    end

    it_behaves_like 'validates xhr'

    it 'returns ok' do
      expect(response).to have_http_status(:ok)
    end

    context 'when params are invalid' do
      let(:params) { { q: 'query', limit: 'invalid' } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end
end
