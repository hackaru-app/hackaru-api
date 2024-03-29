# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.safe_email }
    password { Faker::Internet.password }
    receive_week_report { Faker::Boolean.boolean }
    receive_month_report { Faker::Boolean.boolean }
    time_zone { ActiveSupport::TimeZone::MAPPING.values.sample }
    locale { I18n.available_locales.map(&:to_s).sample }
    start_day { Random.rand(0..6) }
  end
end
