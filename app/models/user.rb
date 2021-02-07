# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email,
            presence: true,
            uniqueness: true,
            length: { maximum: 191 },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { in: 6..50 }, allow_nil: true
  validates :time_zone, presence: true, inclusion: { in: ActiveSupport::TimeZone::MAPPING.values }
  validates :locale, presence: true, inclusion: { in: :locales }

  with_options dependent: :delete do
    has_one :password_reset_token
    has_one :activity_calendar
  end

  with_options dependent: :delete_all do
    has_many :projects
    has_many :activities
    has_many :auth_tokens
  end

  def reset_password(token:, password:, password_confirmation:)
    return false if password_reset_token&.expired?
    return false if password_reset_token != token

    update!(
      password: password,
      password_confirmation: password_confirmation
    )
    password_reset_token.destroy!
    true
  end

  private

  def locales
    I18n.available_locales.map(&:to_s)
  end
end
