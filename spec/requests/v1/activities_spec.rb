# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Activities', type: :request do
  describe 'GET /v1/activities' do
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

    it_behaves_like 'validates xhr'

    it_behaves_like 'authorizes doorkeeper' do
      let(:scopes) { 'activities:read' }
    end

    context 'when params are correctly' do
      it { expect(response).to have_http_status(:ok) }
    end

    context 'when params are missing' do
      let(:params) { {} }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end

  describe 'GET /v1/activities/working' do
    let(:headers) { xhr_header }

    before do
      login
      get '/v1/activities/working',
          headers: headers
    end

    it_behaves_like 'validates xhr'

    it_behaves_like 'authorizes doorkeeper' do
      let(:scopes) { 'activities:read' }
    end

    it 'returns ok' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /v1/activities' do
    let(:headers) { xhr_header }
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
           headers: headers,
           params: params
    end

    it_behaves_like 'validates xhr'

    it_behaves_like 'authorizes doorkeeper' do
      let(:scopes) { 'activities:write' }
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
    let(:headers) { xhr_header }
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
          headers: headers,
          params: params
    end

    it_behaves_like 'validates xhr'

    it_behaves_like 'authorizes doorkeeper' do
      let(:scopes) { 'activities:write' }
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
    let(:headers) { xhr_header }
    let(:activity) { create(:activity) }
    let(:id) { activity.id }

    before do
      login(activity.user)
      delete "/v1/activities/#{id}",
             headers: headers
    end

    it_behaves_like 'validates xhr'

    it_behaves_like 'authorizes doorkeeper' do
      let(:scopes) { 'activities:write' }
    end

    context 'when activity exists' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(Activity).not_to exist(id: id) }
    end

    context 'when activity does not exist' do
      let(:id) { 'invalid' }

      it { expect(response).to have_http_status(:not_found) }
    end
  end
end
