# frozen_string_literal: true

FactoryBot.define do
  factory :user_settings do
    user
    receive_weekly_report { Faker::Boolean.boolean }
    receive_monthly_report { Faker::Boolean.boolean }

    after(:build) do |user_settings|
      user_setting.user ||= build(:user, user_setting: user_setting)
    end
  end
end
