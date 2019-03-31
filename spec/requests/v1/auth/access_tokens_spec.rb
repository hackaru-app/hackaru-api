# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Auth::AccessTokens', type: :request do
  describe 'POST /v1/auth/access_tokens' do
    let(:headers) { refresh_token_header }

    before do
      post '/v1/auth/access_tokens',
           headers: headers
    end

    context 'when client id and token are valid' do
      it { expect(response).to have_http_status(200) }
      it { expect(response.headers['X-Access-Token']).to_not be_nil }
    end

    context 'when client id is invalid' do
      let(:headers) { refresh_token_header.merge('X-Client-Id': 'invalid') }
      it { expect(response).to have_http_status(401) }
      it { expect(response.headers['X-Access-Token']).to be_nil }
    end

    context 'when refresh token is invalid' do
      let(:headers) { refresh_token_header.merge('X-Refresh-Token': 'invalid') }
      it { expect(response).to have_http_status(401) }
      it { expect(response.headers['X-Access-Token']).to be_nil }
    end
  end
end
