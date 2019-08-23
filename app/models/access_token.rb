# frozen_string_literal: true

class AccessToken
  SECRET = ENV.fetch('JWT_SECRET', Rails.application.secret_key_base)
  private_constant :SECRET

  def initialize(user:, exp: 10 * 60)
    @user = user
    @exp = exp
  end

  def issue
    data = { id: @user.id, email: @user.email }
    JWT.encode({ data: data, exp: Time.now.to_i + @exp }, SECRET, 'HS256')
  end

  def self.verify(jwt)
    options = { exp_leeway: 30, algorithm: 'HS256' }
    decoded = JWT.decode(jwt, SECRET, true, options)[0]['data']
    return nil unless decoded

    User.find_by(id: decoded['id'], email: decoded['email'])
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end
end
