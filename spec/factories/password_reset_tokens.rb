# frozen_string_literal: true

FactoryBot.define do
  factory :password_reset_token do
    user
    token { Faker::Internet.password }
    expired_at { Time.zone.now + 5.minutes }
  end
end
