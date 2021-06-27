# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::MustHaveSurveys', type: :request do
  describe 'GET /v1/must_have_survey/answerable' do
    let(:headers) { xhr_header }
    let(:user) { create(:user) }

    before do
      login(user)
      get '/v1/must_have_survey/answerable', headers: headers
    end

    it_behaves_like 'validates xhr'

    context 'when user is answerable' do
      let(:expected_json) { { answerable: true }.to_json }
      let(:user) do
        user = create(:user, created_at: Time.zone.now - 60.days)
        create_list(:activity, 10, user: user)
        user
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to be_json_eql(expected_json) }
    end

    context 'when user is not answerable' do
      let(:expected_json) { { answerable: false }.to_json }
      let(:user) { create(:must_have_survey).user }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to be_json_eql(expected_json) }
    end
  end

  describe 'POST /v1/must_have_survey' do
    let(:headers) { xhr_header }
    let(:user) { create(:user) }

    let(:params) do
      {
        must_have_survey: {
          must_have_level: 0,
          alternative_present: true,
          alternative_detail: 'alternative_detail',
          core_value: 'core_value',
          recommended: true,
          recommended_detail: 'recommended_detail',
          target_user_detail: 'target_user_detail',
          feature_request: 'feature_request',
          interview_accept: true,
          email: 'test@example.com',
          locale: 'ja'
        }
      }
    end

    before do
      login(user)
      post '/v1/must_have_survey', params: params, headers: headers
    end

    it_behaves_like 'validates xhr'

    context 'when user is not answered yet' do
      it { expect(response).to have_http_status(:ok) }
      it { expect(user.must_have_survey).not_to be_nil }
    end

    context 'when user has already answered' do
      let(:user) { create(:must_have_survey).user }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(user.must_have_survey).not_to be_nil }
    end
  end
end
