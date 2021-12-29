# frozen_string_literal: true

FactoryBot.define do
  factory :password_reset_token do
    user
    token { Faker::Internet.password }
    expired_at { 5.minutes.from_now }
  end
end
