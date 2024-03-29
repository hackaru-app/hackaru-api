# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Users', type: :request do
  describe 'GET /v1/user' do
    let(:headers) { xhr_header }
    let(:user) { create(:user) }

    before do
      login(user)
      get '/v1/user', headers: headers
    end

    it_behaves_like 'validates xhr'

    it_behaves_like 'authorizes doorkeeper' do
      let(:scopes) { 'user:read' }
    end

    it 'returns ok' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /v1/user' do
    let(:headers) { xhr_header }
    let(:user) { create(:user) }
    let(:params) do
      {
        user: {
          time_zone: 'Etc/UTC',
          receive_week_report: true,
          receive_month_report: true,
          start_day: 0
        }
      }
    end

    before do
      login(user)
      put '/v1/user', headers: headers, params: params
    end

    it_behaves_like 'validates xhr'

    context 'when params are correctly' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(user.reload.time_zone).to eq('Etc/UTC') }
      it { expect(user.reload.receive_week_report).to be(true) }
      it { expect(user.reload.receive_month_report).to be(true) }
      it { expect(user.reload.start_day).to eq(0) }
    end

    context 'when params are missing' do
      let(:params) { {} }

      it { expect(response).to have_http_status(:bad_request) }
    end

    context 'when params have email' do
      let(:user) { create(:user, email: 'test@example.com') }
      let(:params) { { user: { email: 'changed@example.com' } } }

      it { expect(response).to have_http_status(:ok) }
      it { expect(user.reload.email).to eq('test@example.com') }
    end

    context 'when params have password' do
      let(:user) { create(:user, password: 'password') }
      let(:params) { { user: { password: 'changed' } } }

      it { expect(response).to have_http_status(:ok) }
      it { expect(user.reload.password).to eq('password') }
    end
  end
end
