# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OAuth::Applications', type: :request do
  describe 'GET /oauth/authorized_applications' do
    let(:headers) { xhr_header }
    let(:user) { create(:user) }

    before do
      login(user)
      create(:oauth_access_token, resource_owner_id: user.id)
      get '/oauth/authorized_applications',
          headers: headers
    end

    it_behaves_like 'validates xhr'

    it 'returns ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'does not include client secret' do
      expect(JSON.parse(response.body)[0]).not_to be_include 'secret'
    end
  end

  describe 'DELETE /oauth/authorized_applications' do
    let(:headers) { xhr_header }
    let(:application) { create(:oauth_application) }
    let(:user) { create(:user) }

    let!(:access_token) do
      create(
        :oauth_access_token,
        resource_owner_id: user.id,
        application: application
      )
    end

    let!(:access_grant) do
      create(
        :oauth_access_grant,
        resource_owner_id: user.id,
        application: application
      )
    end

    before do
      login(user)
      delete "/oauth/authorized_applications/#{application.id}",
             headers: headers
    end

    it_behaves_like 'validates xhr'

    context 'when application exists' do
      it { expect(response).to have_http_status(:no_content) }
      it { expect(access_token.reload.revoked_at).not_to be_nil }
      it { expect(access_grant.reload.revoked_at).not_to be_nil }
    end

    context 'when application does not exist' do
      it { expect(response).to have_http_status(:no_content) }
    end
  end
end
