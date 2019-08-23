# frozen_string_literal: true

FactoryBot.define do
  factory :activity do
    user
    project { create(:project, user: user) }
    description { Faker::Job.title }
    started_at { Faker::Date.between(from: 7.days.ago, to: 4.days.ago) }
    stopped_at { Faker::Date.between(from: 3.days.ago, to: 1.days.ago) }
  end
end
