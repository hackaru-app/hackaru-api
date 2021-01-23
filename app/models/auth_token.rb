# frozen_string_literal: true

class AuthToken < ApplicationRecord
  EXPIRES_PERIOD = 1.year.freeze
  private_constant :EXPIRES_PERIOD

  belongs_to :user

  before_create :hash_token

  def revoke
    update!(expired_at: Time.zone.now)
  end

  def self.fetch(id, raw)
    return unless id && raw

    auth_token = find_by(id: id)
    auth_token if
      auth_token &&
      auth_token.expired_at > Time.zone.now &&
      BCrypt::Password.new(auth_token.token) == raw
  end

  def self.issue!(user)
    raw = SecureRandom.urlsafe_base64
    auth_token = AuthToken.create!(
      user: user,
      token: raw,
      expired_at: EXPIRES_PERIOD.from_now
    )
    [auth_token, raw]
  end

  private

  def hash_token
    self.token = BCrypt::Password.create(token)
  end
end
