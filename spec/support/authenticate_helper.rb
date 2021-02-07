# frozen_string_literal: true

module AuthenticateHelper
  def login(user = create(:user))
    return unless user

    auth_token = create(:auth_token, user: user, token: 'secret')
    store_signed_cookie(:auth_token_id, auth_token.id)
    store_signed_cookie(:auth_token_raw, 'secret')
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
end
