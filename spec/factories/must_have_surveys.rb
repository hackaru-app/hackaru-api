# frozen_string_literal: true

FactoryBot.define do
  factory :must_have_survey do
    user
    must_have_level { Faker::Number.between(from: 0, to: 3) }
    alternative_present { true }
    alternative_detail { Faker::Lorem.sentence }
    recommended { true }
    recommended_detail { Faker::Lorem.sentence }
    core_value { Faker::Lorem.sentence }
    target_user_detail { Faker::Lorem.sentence }
    feature_request { Faker::Lorem.sentence }
    interview_accept { true }
    email { Faker::Internet.unique.safe_email }
    locale { I18n.available_locales.map(&:to_s).sample }
  end
end
