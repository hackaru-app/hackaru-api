# frozen_string_literal: true

class UserSetting < ApplicationRecord
  belongs_to :user

  validates :receive_weekly_report, presence: true
  validates :receive_monthly_report, presence: true
end
