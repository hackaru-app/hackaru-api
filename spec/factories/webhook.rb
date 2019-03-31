# frozen_string_literal: true

FactoryBot.define do
  factory :webhook do
    user
    target_url { Faker::Internet.url }
    event { "#{Faker::Hacker.noun}:#{Faker::Hacker.verb}" }
  end
end
