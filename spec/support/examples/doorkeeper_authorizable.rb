# frozen_string_literal: true

shared_examples 'authorizes doorkeeper' do
  let(:access_token) { create(:oauth_access_token, scopes: scopes) }
  let(:headers) { { Authorization: "Bearer #{access_token.token}" } }

  context 'when token has required scopes' do
    it { expect(response).not_to have_http_status(:forbidden) }
  end

  context 'when token does not have required scopes' do
    let(:scopes) { '' }

    it { expect(response).to have_http_status(:forbidden) }
  end
end
