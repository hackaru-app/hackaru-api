# frozen_string_literal: true

class PasswordResetToken < ApplicationRecord
  belongs_to :user
  before_save :hash_token

  def ==(other)
    ::BCrypt::Password.new(token) == other
  end

  def expired?
    expired_at <= Time.zone.now
  end

  def self.issue(user)
    raw = SecureRandom.urlsafe_base64(nil, false)
    password_reset_token = PasswordResetToken.find_or_initialize_by(user: user)
    password_reset_token.update!(token: raw, expired_at: 5.minutes.from_now)
    raw
  end

  private

  def hash_token
    self.token = BCrypt::Password.create(token)
  end
end
