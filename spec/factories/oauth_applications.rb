# frozen_string_literal: true

FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { Faker::App.name }
    uid  { Faker::Crypto.sha256 }
    secret { Faker::Crypto.sha256 }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    scopes { '' }
    association :owner, factory: :user
  end
end
