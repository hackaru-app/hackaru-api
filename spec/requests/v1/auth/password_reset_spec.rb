# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Auth::PasswordReset', type: :request do
  describe 'POST /v1/auth/password_reset/mails' do
    let(:user) { create(:user) }
    let(:email) { user.email }

    before do
      perform_enqueued_jobs do
        post '/v1/auth/password_reset/mails',
             headers: xhr_header,
             params: {
               user: {
                 email: email
               }
             }
      end
    end

    context 'when email is registered' do
      it { expect(response).to have_http_status(:no_content) }
      it { expect(ActionMailer::Base.deliveries.size).to eq(1) }
      it { expect(ActionMailer::Base.deliveries.last.to.first).to eq(email) }
    end

    context 'when email is not registered' do
      let(:email) { 'invalid' }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'PUT /v1/auth/password_reset' do
    let(:user) { create(:user) }

    before do
      create(:password_reset_token, user: user, token: 'secret')
      put '/v1/auth/password_reset',
          headers: xhr_header,
          params: {
            user: {
              id: user.id,
              token: token,
              password: 'changed',
              password_confirmation: 'changed'
            }
          }
    end

    context 'when token is valid' do
      let(:token) { 'secret' }

      it { expect(response).to have_http_status(:no_content) }
      it { expect(user.reload.authenticate('changed')).to be_truthy }
    end

    context 'when token is invalid' do
      let(:token) { 'invalid' }

      it { expect(response).to have_http_status(:bad_request) }
      it { expect(user.reload.authenticate('changed')).to be_falsy }
    end
  end
end
