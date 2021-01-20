# frozen_string_literal: true

module AuthTokenStorable
  private

  def store_auth_token(auth_token, raw)
    store_signed_cookie(
      :auth_token_id,
      auth_token.id,
      auth_token.expired_at
    )
    store_signed_cookie(
      :auth_token_raw,
      raw,
      auth_token.expired_at
    )
  end

  def store_signed_cookie(key, value, expires)
    cookies.signed[key] = {
      value: value,
      expires: expires,
      path: '/',
      same_site: :lax,
      domain: :all,
      secure: Rails.env.production?,
      httponly: true
    }
  end

  def restore_auth_token
    AuthToken.fetch(
      cookies.signed[:auth_token_id],
      cookies.signed[:auth_token_raw]
    )
  end

  def revoke_auth_token
    restore_auth_token&.revoke
    cookies.delete(:auth_token_id, domain: :all)
    cookies.delete(:auth_token_raw, domain: :all)
  end
end
