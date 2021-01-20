# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Auth::RefreshTokens', type: :request do
  describe 'POST /v1/auth/refresh_tokens' do
    let(:user) { create(:user, password: 'password') }
    let(:email) { user.email }
    let(:password) { 'password' }

    before do
      post '/v1/auth/refresh_tokens',
           params: {
             user: {
               email: email,
               password: password
             }
           }
    end

    context 'when params are valid' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(response.headers['X-Client-Id']).not_to be_nil }
      it { expect(response.headers['X-Refresh-Token']).not_to be_nil }
      it { expect(response.cookies['auth_token_id']).not_to be_nil }
      it { expect(response.cookies['auth_token_raw']).not_to be_nil }
    end

    context 'when email is not registration' do
      let(:email) { 'invalid' }

      it { expect(response).to have_http_status(:bad_request) }
      it { expect(response.headers['X-Client-Id']).to be_nil }
      it { expect(response.headers['X-Refresh-Token']).to be_nil }
      it { expect(response.cookies).not_to include('auth_token_id') }
      it { expect(response.cookies).not_to include('auth_token_raw') }
    end

    context 'when password is invalid' do
      let(:password) { 'invalid' }

      it { expect(response).to have_http_status(:bad_request) }
      it { expect(response.headers['X-Client-Id']).to be_nil }
      it { expect(response.headers['X-Refresh-Token']).to be_nil }
      it { expect(response.cookies).not_to include('auth_token_id') }
      it { expect(response.cookies).not_to include('auth_token_raw') }
    end
  end

  describe 'DELETE /v1/auth/refresh_token' do
    let(:headers) { refresh_token_header(user) }
    let(:user) { create(:user) }

    before do
      login(user)
      delete '/v1/auth/refresh_token',
             headers: headers
    end

    context 'when refresh token and client id are valid' do
      it { expect(response).to have_http_status(:no_content) }
      it { expect(response.cookies).to include('auth_token_id') }
      it { expect(response.cookies).to include('auth_token_raw') }
      it { expect(response.cookies['auth_token_id']).to be_nil }
      it { expect(response.cookies['auth_token_raw']).to be_nil }
    end

    context 'when client id is invalid' do
      let(:headers) { refresh_token_header.merge('X-Client-Id': 'invalid') }

      it { expect(response).to have_http_status(:no_content) }
      it { expect(response.cookies).to include('auth_token_id') }
      it { expect(response.cookies).to include('auth_token_raw') }
      it { expect(response.cookies['auth_token_id']).to be_nil }
      it { expect(response.cookies['auth_token_raw']).to be_nil }
    end

    context 'when refresh token is invalid' do
      let(:headers) { refresh_token_header.merge('X-Refresh-Token': 'invalid') }

      it { expect(response).to have_http_status(:no_content) }
      it { expect(response.cookies).to include('auth_token_id') }
      it { expect(response.cookies).to include('auth_token_raw') }
      it { expect(response.cookies['auth_token_id']).to be_nil }
      it { expect(response.cookies['auth_token_raw']).to be_nil }
    end
  end
end
