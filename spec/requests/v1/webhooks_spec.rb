# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Webhooks', type: :request do
  describe 'GET /v1/webhooks' do
    before do
      get '/v1/webhooks',
          headers: access_token_header
    end

    it 'returns http success' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /v1/webhooks' do
    let(:user) { create(:user) }
    let(:target_url) { 'http://example.com' }
    let(:params) do
      {
        webhook: {
          target_url: target_url,
          event: 'project:created'
        }
      }
    end

    before do
      post '/v1/webhooks',
           headers: access_token_header(user),
           params: params
    end

    context 'when params are correctly' do
      it { expect(response).to have_http_status(200) }
      it { expect(user.webhooks.first).to_not be_nil }
    end

    context 'when params are invalid' do
      let(:target_url) { 'invalid' }
      it { expect(response).to have_http_status(422) }
    end

    context 'when params are missing' do
      let(:params) { {} }
      it { expect(response).to have_http_status(400) }
    end
  end

  describe 'PUT /v1/webhooks' do
    let(:webhook) { create(:webhook) }
    let(:id) { webhook.id }
    let(:target_url) { 'http://updated.com' }
    let(:params) do
      {
        webhook: {
          target_url: target_url
        }
      }
    end

    before do
      put "/v1/webhooks/#{id}",
          headers: access_token_header(webhook.user),
          params: params
    end

    context 'when webhook does not exist' do
      let(:id) { 'invalid' }
      it { expect(response).to have_http_status(404) }
    end

    context 'when params are correctly' do
      it { expect(response).to have_http_status(200) }
      it { expect(webhook.reload.target_url).to eq('http://updated.com') }
    end

    context 'when params are invalid' do
      let(:target_url) { 'invalid' }
      it { expect(response).to have_http_status(422) }
    end

    context 'when params are missing' do
      let(:params) { {} }
      it { expect(response).to have_http_status(400) }
    end
  end

  describe 'DELETE /v1/webhooks' do
    let(:webhook) { create(:webhook) }
    let(:id) { webhook.id }

    before do
      delete "/v1/webhooks/#{id}",
             headers: access_token_header(webhook.user)
    end

    context 'when webhook exists' do
      let(:id) { webhook.id }
      it { expect(response).to have_http_status(200) }
      it { expect(Webhook.exists?(id: id)).to be_falsey }
    end

    context 'when webhook does not exist' do
      let(:id) { 'invalid' }
      it { expect(response).to have_http_status(404) }
    end
  end
end
