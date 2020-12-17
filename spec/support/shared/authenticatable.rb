# frozen_string_literal: true

RSpec.shared_context 'when authentication by oauth' do |scopes|
  let(:current_user) { create(:user) }
  let(:authorization) do
    access_token = create(
      :oauth_access_token,
      resource_owner_id: current_user.id,
      scopes: scopes
    )
    "Bearer #{access_token.token}"
  end
end
