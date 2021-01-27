# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Reports', type: :request do
  describe 'GET /v1/report' do
    let(:user) { create(:user) }

    let(:time_zone) { 'Asia/Tokyo' }
    let(:period) { 'day' }
    let(:params) do
      {
        start: 1.day.ago,
        end: Time.zone.now,
        time_zone: time_zone
      }
    end

    before do
      create_list(:activity, 3, user: user)

      login(user)
      get "/v1/report#{extension}",
          params: params,
          headers: xhr_header
    end

    context 'when extension is empty' do
      let(:extension) { '' }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.content_type).to include('application/json') }
    end

    context 'when extension is html' do
      let(:extension) { '.html' }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.content_type).to include('text/html') }
      it { expect(response.header).not_to include('Link') }
    end

    context 'when extension is pdf' do
      let(:extension) { '.pdf' }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.content_type).to include('application/pdf') }
      it { expect(response.header).not_to include('Link') }
    end

    context 'when extension is csv' do
      let(:extension) { '.csv' }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.content_type).to include('text/csv') }
    end

    context 'when extension is missing' do
      let(:extension) { '.unknown' }

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when tine zone is invalid' do
      let(:extension) { '' }
      let(:time_zone) { 'Eagleland/Onett' }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'when params are missing' do
      let(:extension) { '' }
      let(:params) { {} }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end
end
