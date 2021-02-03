# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Users', type: :request do
  describe 'GET /v1/user' do
    let(:user) { create(:user) }

    before do
      get '/v1/user',
          headers: access_token_header(user)
    end

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /v1/user' do
    let(:user) { create(:user) }
    let(:params) do
      {
        user: {
          time_zone: 'Etc/UTC',
          receive_week_report: true,
          receive_month_report: true
        }
      }
    end

    before do
      put '/v1/user',
          headers: access_token_header(user),
          params: params
    end

    context 'when params are correctly' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(user.reload.time_zone).to eq('Etc/UTC') }
      it { expect(user.reload.receive_week_report).to be(true) }
      it { expect(user.reload.receive_month_report).to be(true) }
    end

    context 'when params are missing' do
      let(:params) { {} }

      it { expect(response).to have_http_status(:bad_request) }
    end

    context 'when params have email' do
      let(:user) { create(:user, email: 'example@example.com') }
      let(:params) { { user: { email: 'changed@example.com' } } }

      it { expect(response).to have_http_status(:ok) }
      it { expect(user.reload.email).to eq('example@example.com') }
    end

    context 'when params have password' do
      let(:user) { create(:user, password: 'password') }
      let(:params) { { user: { password: 'changed' } } }

      it { expect(response).to have_http_status(:ok) }
      it { expect(user.reload.password).to eq('password') }
    end
  end
end
