# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth::Users', type: :request do
  describe 'GET /v1/user' do
    let(:headers) { xhr_header }
    let(:user) { create(:user) }

    before do
      login(user)
      get '/auth/user', headers: headers
    end

    it_behaves_like 'validates xhr'

    it 'returns ok' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /auth/users' do
    let(:headers) { xhr_header }
    let(:email) { 'foo@example.com' }

    before do
      perform_enqueued_jobs do
        post '/auth/users',
             headers: headers,
             params: {
               user: {
                 email: email,
                 password: 'password',
                 time_zone: 'Etc/UTC',
                 locale: 'en',
                 start_day: 0
               }
             }
      end
    end

    it_behaves_like 'validates xhr'

    it 'returns ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'sends mail once' do
      expect(ActionMailer::Base.deliveries.size).to eq(1)
    end

    it 'sends mail' do
      expect(ActionMailer::Base.deliveries.last.to.first).to eq(email)
    end

    it 'creates an user' do
      expect(User.find_by(email: 'foo@example.com')).not_to be_nil
    end

    it 'adds some sample projects' do
      user = User.find_by(email: 'foo@example.com')
      expect(user.projects.size).to eq(3)
    end

    it 'issues auth_token_id' do
      expect(response.cookies['auth_token_id']).not_to be_nil
    end

    it 'issues auth_token_raw' do
      expect(response.cookies['auth_token_raw']).not_to be_nil
    end
  end

  describe 'PUT /auth/user' do
    let(:headers) { xhr_header }
    let(:user) { create(:user, password: 'password') }
    let(:current_user) { user }
    let(:params) do
      {
        user: {
          email: 'changed@example.com',
          password: 'changed',
          current_password: 'password'
        }
      }
    end

    before do
      login(current_user)
      put '/auth/user',
          headers: headers,
          params: params
    end

    it_behaves_like 'validates xhr'

    context 'when params have email and password' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(user.reload.email).to eq('changed@example.com') }
      it { expect(user.reload.authenticate('changed')).to be_truthy }
    end

    context 'when params have email only' do
      let(:params) do
        {
          user: {
            email: 'changed@example.com',
            password: '',
            current_password: 'password'
          }
        }
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(user.reload.email).to eq('changed@example.com') }
    end

    context 'when user is not logged in' do
      let(:current_user) { nil }

      let(:params) do
        {
          user: {
            email: 'changed@example.com',
            password: 'changed',
            current_password: 'password'
          }
        }
      end

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(user.reload.email).not_to eq('changed@example.com') }
    end

    context 'when current password is invalid' do
      let(:params) do
        {
          user: {
            email: 'changed@example.com',
            password: 'changed',
            current_password: 'invalid'
          }
        }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(user.reload.email).not_to eq('changed@example.com') }
    end

    context 'when params are empty' do
      let(:params) { nil }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(user.reload.email).not_to eq('changed@example.com') }
    end
  end

  describe 'DELETE /auth/user' do
    let(:headers) { xhr_header }
    let(:user) { create(:user, password: 'password') }
    let(:current_user) { user }
    let(:current_password) { 'password' }

    before do
      login(current_user)
      delete '/auth/user',
             headers: headers,
             params: {
               user: {
                 current_password: current_password
               }
             }
    end

    it_behaves_like 'validates xhr'

    context 'when current_password is valid' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(User).not_to exist(id: user.id) }
      it { expect(response.cookies).to include('auth_token_id') }
      it { expect(response.cookies).to include('auth_token_raw') }
      it { expect(response.cookies['auth_token_id']).to be_nil }
      it { expect(response.cookies['auth_token_raw']).to be_nil }
    end

    context 'when user is not logged in' do
      let(:current_user) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(User).to exist(id: user.id) }
      it { expect(response.cookies).not_to include('auth_token_id') }
      it { expect(response.cookies).not_to include('auth_token_raw') }
    end

    context 'when current_password is invalid' do
      let(:current_password) { 'invalid' }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(User).to exist(id: user.id) }
      it { expect(response.cookies).not_to include('auth_token_id') }
      it { expect(response.cookies).not_to include('auth_token_raw') }
    end
  end
end
