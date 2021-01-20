# frozen_string_literal: true

FactoryBot.define do
  factory :auth_token do
    user
    token { Faker::Internet.password }
    expired_at { Time.zone.now + 1.day }
  end
end
