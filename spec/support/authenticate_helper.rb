# frozen_string_literal: true

module AuthenticateHelper
  def access_token_header(user = create(:user))
    { 'X-Access-Token': AccessToken.new(user).issue }
  end

  def refresh_token_header(user = create(:user))
    refresh_token = create(:refresh_token, user: user, token: 'secret')
    {
      'X-Client-Id': refresh_token.client_id,
      'X-Refresh-Token': 'secret'
    }
  end
end

RSpec.configure do |config|
  config.include AuthenticateHelper, type: :request
end
