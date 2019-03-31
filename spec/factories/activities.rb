# frozen_string_literal: true

FactoryBot.define do
  factory :activity do
    user
    project { create(:project, user: user) }
    description { Faker::Job.title }
    started_at { Faker::Date.between(7.days.ago, 4.days.ago) }
    stopped_at { Faker::Date.between(3.days.ago, 1.days.ago) }
  end
end
