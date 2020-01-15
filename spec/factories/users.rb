# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password }

    after(:build) do |user|
      user.user_setting ||= build(:user_setting, user: user)
    end
  end
end
