# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Auth::AccessTokens', type: :request do
  describe 'POST /v1/auth/access_tokens' do
    let(:headers) { refresh_token_header(user) }
    let(:user) { create(:user) }
    let(:current_user) { user }

    before do
      login(current_user)
      post '/v1/auth/access_tokens',
           headers: headers
    end

    context 'when client id and token are valid' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(response.headers['X-Access-Token']).not_to be_nil }
    end

    context 'when client id is invalid' do
      let(:headers) { refresh_token_header.merge('X-Client-Id': 'invalid') }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.headers['X-Access-Token']).to be_nil }
      it { expect(response.cookies).not_to include('auth_token_id') }
      it { expect(response.cookies).not_to include('auth_token_raw') }
    end

    context 'when refresh token is invalid' do
      let(:headers) { refresh_token_header.merge('X-Refresh-Token': 'invalid') }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.headers['X-Access-Token']).to be_nil }
      it { expect(response.cookies).not_to include('auth_token_id') }
      it { expect(response.cookies).not_to include('auth_token_raw') }
    end

    context 'when user does not have auth_token' do
      let(:current_user) { nil }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.headers['X-Access-Token']).not_to be_nil }
      it { expect(response.cookies).to include('auth_token_id') }
      it { expect(response.cookies).to include('auth_token_raw') }
    end

    context 'when user has auth_token' do
      let(:current_user) { user }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.headers['X-Access-Token']).not_to be_nil }
      it { expect(response.cookies).not_to include('auth_token_id') }
      it { expect(response.cookies).not_to include('auth_token_raw') }
    end
  end
end
