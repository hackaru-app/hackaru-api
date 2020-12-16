# frozen_string_literal: true

class RefreshToken < ApplicationRecord
  belongs_to :user
  before_save :hash_token

  def ==(other)
    ::BCrypt::Password.new(token) == other
  end

  def revoke(revoked_at = Time.zone.now)
    update!(revoked_at: revoked_at)
  end

  def revoked?
    revoked_at && revoked_at <= Time.zone.now
  end

  def self.issue(user)
    raw = SecureRandom.urlsafe_base64(nil, false)
    refresh_token = create!(
      user: user,
      client_id: SecureRandom.urlsafe_base64(nil, false),
      token: raw
    )
    [refresh_token, raw]
  end

  def self.fetch(client_id:, raw:)
    return nil unless client_id && raw

    refresh_token = find_by(client_id: client_id)
    refresh_token if
      refresh_token &&
      refresh_token == raw &&
      !refresh_token.revoked?
  end

  private

  def hash_token
    self.token = BCrypt::Password.create(token)
  end
end
