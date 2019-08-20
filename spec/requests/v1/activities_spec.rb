# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Activities', type: :request do
  describe 'GET /v1/activities' do
    let(:params) do
      {
        start: 1.days.ago,
        end: Time.now
      }
    end

    before do
      get '/v1/activities',
          headers: access_token_header,
          params: params
    end

    context 'when params are correctly' do
      it { expect(response).to have_http_status(200) }
    end

    context 'when params are missing' do
      let(:params) { {} }
      it { expect(response).to have_http_status(422) }
    end
  end

  describe 'GET /v1/activities/working' do
    before do
      get '/v1/activities/working',
          headers: access_token_header
    end

    it 'returns http success' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /v1/activities' do
    let(:user) { create(:user) }
    let(:started_at) { Time.now }
    let(:params) do
      {
        activity: {
          description: 'Create DB',
          started_at: started_at
        }
      }
    end

    before do
      post '/v1/activities',
           headers: access_token_header(user),
           params: params
    end

    context 'when params are correctly' do
      it { expect(response).to have_http_status(200) }
      it { expect(user.activities.first).to_not be_nil }
    end

    context 'when params are invalid' do
      let(:started_at) { 'invalid' }
      it { expect(response).to have_http_status(422) }
    end

    context 'when params are missing' do
      let(:params) { {} }
      it { expect(response).to have_http_status(400) }
    end
  end

  describe 'PUT /v1/activities' do
    let(:activity) { create(:activity) }
    let(:started_at) { Time.now }
    let(:id) { activity.id }
    let(:params) do
      {
        activity: {
          description: 'Updated',
          started_at: started_at,
          stopped_at: Time.now + 1.day
        }
      }
    end

    before do
      put "/v1/activities/#{id}",
          headers: access_token_header(activity.user),
          params: params
    end

    context 'when activity does not exist' do
      let(:id) { 'invalid' }
      it { expect(response).to have_http_status(404) }
    end

    context 'when params are correctly' do
      it { expect(response).to have_http_status(200) }
      it { expect(activity.reload.description).to eq('Updated') }
    end

    context 'when params are invalid' do
      let(:started_at) { 'invalid' }
      it { expect(response).to have_http_status(422) }
    end

    context 'when params are missing' do
      let(:params) { {} }
      it { expect(response).to have_http_status(400) }
    end
  end

  describe 'DELETE /v1/activities' do
    let(:activity) { create(:activity) }

    before do
      delete "/v1/activities/#{id}",
             headers: access_token_header(activity.user)
    end

    context 'when activity exists' do
      let(:id) { activity.id }
      it { expect(response).to have_http_status(200) }
      it { expect(Activity.exists?(id: id)).to be_falsey }
    end

    context 'when activity does not exist' do
      let(:id) { 'invalid' }
      it { expect(response).to have_http_status(404) }
    end
  end
end
