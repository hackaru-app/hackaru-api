# frozen_string_literal: true

FactoryBot.define do
  factory :auth_token do
    user
    token { Faker::Internet.password }
    expired_at { 1.day.from_now }
  end
end
