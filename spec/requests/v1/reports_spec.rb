# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Reports', type: :request do
  describe 'GET /v1/report' do
    let(:time_zone) { 'Asia/Tokyo' }
    let(:period) { 'day' }
    let(:params) do
      {
        start: 1.days.ago,
        end: Time.now,
        time_zone: time_zone
      }
    end

    before do
      get "/v1/report#{extension}",
          params: params,
          headers: access_token_header
    end

    context 'when extension is empty' do
      let(:extension) { '' }
      it { expect(response).to have_http_status(200) }
      it { expect(response.content_type).to eq('application/json') }
    end

    context 'when extension is html' do
      let(:extension) { '.html' }
      it { expect(response).to have_http_status(200) }
      it { expect(response.content_type).to eq('text/html') }
    end

    context 'when extension is pdf' do
      let(:extension) { '.pdf' }
      it { expect(response).to have_http_status(200) }
      it { expect(response.content_type).to eq('application/pdf') }
    end

    context 'when extension is missing' do
      let(:extension) { '.unknown' }
      it { expect(response).to have_http_status(404) }
    end

    context 'when tine zone is invalid' do
      let(:extension) { '' }
      let(:time_zone) { 'Eagleland/Onett' }
      it { expect(response).to have_http_status(422) }
    end

    context 'when params are missing' do
      let(:extension) { '' }
      let(:params) { {} }
      it { expect(response).to have_http_status(422) }
    end
  end
end
