# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Activities', type: :request do
  describe 'GET /v1/activities (access_token)' do
    let(:params) do
      {
        start: 1.day.ago,
        end: Time.zone.now
      }
    end

    before do
      login
      get '/v1/activities',
          headers: xhr_header,
          params: params
    end

    context 'when params are correctly' do
      it { expect(response).to have_http_status(:ok) }
    end

    context 'when params are missing' do
      let(:params) { {} }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end

  describe 'GET /v1/activities (auth_token)' do
    let(:headers) { xhr_header }
    let(:params) do
      {
        start: 1.day.ago,
        end: Time.zone.now
      }
    end

    before do
      login
      get '/v1/activities',
          headers: headers,
          params: params
    end

    context 'when params are correctly' do
      it { expect(response).to have_http_status(:ok) }
    end

    context 'when params are missing' do
      let(:params) { {} }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'when xhr header is missing' do
      let(:headers) { {} }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'GET /v1/activities (access_token, auth_token)' do
    let(:auth_token_user) { create(:user) }
    let(:access_token_user) { create(:user) }
    let(:params) do
      {
        start: 1.day.ago,
        end: Time.zone.now
      }
    end

    before do
      login(auth_token_user)
      create(
        :activity,
        user: access_token_user,
        started_at: 1.minute.ago,
        stopped_at: 1.minute.ago
      )
      get '/v1/activities',
          headers: access_token_header(access_token_user),
          params: params
    end

    context 'when params are correctly' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(JSON.parse!(response.body).first['id']).to eq(access_token_user.activities.first.id) }
    end

    context 'when params are missing' do
      let(:params) { {} }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end

  describe 'GET /v1/activities/working' do
    before do
      login
      get '/v1/activities/working',
          headers: xhr_header
    end

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /v1/activities' do
    let(:user) { create(:user) }
    let(:started_at) { Time.zone.now }
    let(:params) do
      {
        activity: {
          description: 'Create DB',
          started_at: started_at
        }
      }
    end

    before do
      login(user)
      post '/v1/activities',
           headers: xhr_header,
           params: params
    end

    context 'when params are correctly' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(user.activities.first).not_to be_nil }
    end

    context 'when params are invalid' do
      let(:started_at) { 'invalid' }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'when params are missing' do
      let(:params) { {} }

      it { expect(response).to have_http_status(:bad_request) }
    end
  end

  describe 'PUT /v1/activities' do
    let(:activity) { create(:activity) }
    let(:started_at) { Time.zone.now }
    let(:id) { activity.id }
    let(:params) do
      {
        activity: {
          description: 'Updated',
          started_at: started_at,
          stopped_at: Time.zone.now + 1.day
        }
      }
    end

    before do
      login(activity.user)
      put "/v1/activities/#{id}",
          headers: xhr_header,
          params: params
    end

    context 'when activity does not exist' do
      let(:id) { 'invalid' }

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when params are correctly' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(activity.reload.description).to eq('Updated') }
    end

    context 'when params are invalid' do
      let(:started_at) { 'invalid' }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'when params are missing' do
      let(:params) { {} }

      it { expect(response).to have_http_status(:bad_request) }
    end
  end

  describe 'DELETE /v1/activities' do
    let(:activity) { create(:activity) }

    before do
      login(activity.user)
      delete "/v1/activities/#{id}",
             headers: xhr_header
    end

    context 'when activity exists' do
      let(:id) { activity.id }

      it { expect(response).to have_http_status(:ok) }
      it { expect(Activity).not_to exist(id: id) }
    end

    context 'when activity does not exist' do
      let(:id) { 'invalid' }

      it { expect(response).to have_http_status(:not_found) }
    end
  end
end
