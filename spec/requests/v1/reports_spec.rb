# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Reports', type: :request do
  describe 'GET /v1/reports' do
    let(:time_zone) { 'Asia/Tokyo' }
    let(:period) { 'day' }
    let(:params) do
      {
        start: 1.days.ago,
        end: Time.now,
        period: period,
        time_zone: time_zone
      }
    end

    before do
      get '/v1/reports',
          params: params,
          headers: access_token_header
    end

    context 'when params are correctly' do
      it { expect(response).to have_http_status(200) }
    end

    context 'when period is invalid' do
      let(:period) { 'century' }
      it { expect(response).to have_http_status(422) }
    end

    context 'when tine zone is invalid' do
      let(:time_zone) { 'Eagleland/Onett' }
      it { expect(response).to have_http_status(422) }
    end

    context 'when params are missing' do
      let(:params) { {} }
      it { expect(response).to have_http_status(422) }
    end
  end
end
