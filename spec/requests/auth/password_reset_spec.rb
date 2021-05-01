# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth::PasswordReset', type: :request do
  describe 'POST /auth/password_reset/mails' do
    let(:headers) { xhr_header }
    let(:user) { create(:user) }
    let(:email) { user.email }

    before do
      perform_enqueued_jobs do
        post '/auth/password_reset/mails',
             headers: headers,
             params: {
               user: {
                 email: email
               }
             }
      end
    end

    it_behaves_like 'validates xhr'

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

  describe 'PUT /auth/password_reset' do
    let(:headers) { xhr_header }
    let(:user) { create(:user) }
    let(:token) { 'secret' }

    before do
      create(:password_reset_token, user: user, token: 'secret')
      put '/auth/password_reset',
          headers: headers,
          params: {
            user: {
              id: user.id,
              token: token,
              password: 'changed',
              password_confirmation: 'changed'
            }
          }
    end

    it_behaves_like 'validates xhr'

    context 'when token is valid' do
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
