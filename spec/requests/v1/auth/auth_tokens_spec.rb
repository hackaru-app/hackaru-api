# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Auth::AuthTokens', type: :request do
  describe 'POST /v1/auth/auth_tokens' do
    let(:user) { create(:user) }

    before do
      post '/v1/auth/auth_tokens',
           headers: xhr_header,
           params: {
             user: {
               email: email,
               password: password
             }
           }
    end

    context 'when email and password are valid' do
      let(:email) { user.email }
      let(:password) { user.password }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.cookies).to include('auth_token_id') }
      it { expect(response.cookies).to include('auth_token_raw') }
    end

    context 'when email is invalid' do
      let(:email) { 'example@example.com' }
      let(:password) { user.password }

      it { expect(response).to have_http_status(:bad_request) }
    end

    context 'when password is invalid' do
      let(:email) { user.email }
      let(:password) { 'invalid' }

      it { expect(response).to have_http_status(:bad_request) }
    end
  end

  describe 'DELETE /v1/auth/auth_tokens' do
    before do
      login(current_user)
      delete '/v1/auth/auth_token',
             headers: xhr_header
    end

    around do |e|
      travel_to('2021-01-01 00:00:00') { e.run }
    end

    context 'when user logged in' do
      let(:current_user) { create(:user) }

      it { expect(response).to have_http_status(:no_content) }
      it { expect(current_user.auth_tokens.first.expired_at).to eq(Time.zone.now) }
    end

    context 'when user is not logged in' do
      let(:current_user) { nil }

      it { expect(response).to have_http_status(:no_content) }
    end
  end
end
