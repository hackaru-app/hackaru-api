# frozen_string_literal: true

FactoryBot.define do
  factory :oauth_access_token, class: 'Doorkeeper::AccessToken' do
    resource_owner_id { create(:user).id }
    association :application, factory: :oauth_application
    token { Faker::Crypto.sha256 }
    scopes { '' }
  end
end
