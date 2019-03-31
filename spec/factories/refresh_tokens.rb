# frozen_string_literal: true

FactoryBot.define do
  factory :refresh_token do
    user
    client_id { Faker::Internet.password }
    token { Faker::Internet.password }
    revoked_at { nil }
  end
end
