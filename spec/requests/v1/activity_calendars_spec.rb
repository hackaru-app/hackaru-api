# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::ActivityCalendars', type: :request do
  describe 'GET /v1/activity_calendar' do
    let(:activity_calendar) { create(:activity_calendar) }
    let(:params) do
      {
        token: token,
        user_id: user_id
      }
    end

    let(:blank) do
      cal = <<~CAL
        BEGIN:VCALENDAR
        VERSION:2.0
        PRODID:icalendar-ruby
        CALSCALE:GREGORIAN
        X-WR-CALNAME;VALUE=TEXT:Hackaru
        END:VCALENDAR
      CAL
      cal.gsub("\n", "\r\n")
    end

    before do
      create_list(:activity, 3, user: activity_calendar.user)
      get '/v1/activity_calendar', params: params
    end

    context 'when params are correctly' do
      let(:token) { activity_calendar.token }
      let(:user_id) { activity_calendar.user.id }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to eq(blank) }
    end

    context 'when params are missing' do
      let(:params) { {} }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'when user_id is invalid' do
      let(:token) { activity_calendar.token }
      let(:user_id) { 0 }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to eq(blank) }
    end

    context 'when the token is for another user' do
      let(:token) { create(:activity_calendar).token }
      let(:user_id) { create(:activity_calendar).user_id }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to eq(blank) }
    end

    context 'when the token is invalid' do
      let(:token) { 'invalid' }
      let(:user_id) { activity_calendar.user.id }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to eq(blank) }
    end

    context 'when params have no token and an user has no token' do
      let(:params) { { user_id: create(:user).id } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'when the token is blank and an user has no token' do
      let(:params) { { token: '', user_id: create(:user).id } }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to eq(blank) }
    end

    context 'when the token is zero and an user has no token' do
      let(:params) { { token: 0, user_id: create(:user).id } }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to eq(blank) }
    end

    context 'when the token is false and an user has no token' do
      let(:params) { { token: false, user_id: create(:user).id } }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to eq(blank) }
    end

    context 'when the token is nil and an user has no token' do
      let(:params) { { token: nil, user_id: create(:user).id } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'when the user_id param has multiple ids' do
      let(:token) { activity_calendar.token }
      let(:user_id) { [activity_calendar.user.id, create(:user).id] }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end

  describe 'PUT /v1/activity_calendar' do
    let(:headers) { xhr_header }
    let(:user) { create(:user) }

    before do
      login(user)
      put '/v1/activity_calendar',
          headers: headers
    end

    it_behaves_like 'validates xhr'

    context 'when params are correctly' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(user.activity_calendar).to be_present }
    end

    context 'when user already has activity_calendar' do
      let(:activity_calendar) { create(:activity_calendar) }
      let(:user) { activity_calendar.user }

      it { expect(response).to have_http_status(:ok) }
      it { expect(user.activity_calendar).to eq(activity_calendar) }
    end
  end

  describe 'DELETE /v1/activity_calendar' do
    let(:headers) { xhr_header }
    let(:activity_calendar) { create(:activity_calendar) }
    let(:user) { activity_calendar.user }

    before do
      login(user)
      delete '/v1/activity_calendar',
             headers: headers
    end

    it_behaves_like 'validates xhr'

    context 'when user has activity_calendar' do
      it { expect(response).to have_http_status(:no_content) }
      it { expect(user.reload.activity_calendar).to be_nil }
    end

    context 'when user does not have activity_calendar' do
      let(:user) { create(:user) }

      it { expect(response).to have_http_status(:no_content) }
    end
  end
end
