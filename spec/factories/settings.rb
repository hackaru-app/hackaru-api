# frozen_string_literal: true

FactoryBot.define do
  factory :settings do
    user
    receive_weekly_report { Faker::Boolean.boolean }
    receive_monthly_report { Faker::Boolean.boolean }

    after(:build) do |settings|
      settings.user ||= build(:user, settings: settings)
    end
  end
end
