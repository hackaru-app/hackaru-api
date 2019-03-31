# frozen_string_literal: true

FactoryBot.define do
  factory :oauth_access_grant, class: 'Doorkeeper::AccessGrant' do
    resource_owner_id { create(:user).id }
    association :application, factory: :oauth_application
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    expires_in { 100 }
    scopes { '' }
  end
end
