# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    user
    name { Faker::Job.unique.title }
    color { Faker::Color.hex_color }
  end
end
