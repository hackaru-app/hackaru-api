# frozen_string_literal: true

FactoryBot.define do
  factory :suggestion do
    project
    description { Faker::Job.title }

    skip_create
    initialize_with { new(attributes) }
  end
end
