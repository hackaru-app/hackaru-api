# frozen_string_literal: true

module AuthenticateHelper
  def login(user = create(:user))
    return unless user

    auth_token = create(:auth_token, user: user, token: 'secret')
    store_auth_token(auth_token.id, 'secret')
  end

  def store_auth_token(id, raw)
    store_signed_cookie(:auth_token_id, id)
    store_signed_cookie(:auth_token_raw, raw)
  end

  private

  def store_signed_cookie(key, value)
    env_config = Rails.application.env_config.deep_dup
    cookie_jar = ActionDispatch::Request.new(env_config).cookie_jar
    cookie_jar.signed[key] = value
    cookies[key] = cookie_jar[key]
  end
end

RSpec.configure do |config|
  config.include AuthenticateHelper, type: :request
  config.include AuthenticateHelper, type: :controller
end
