# frozen_string_literal: true

module Authenticatable
  attr_reader :current_user

  private

  def authenticate_user!(*scopes)
    if scopes.present? && request.headers['Authorization']
      authenticate_doorkeeper!(*scopes)
    else
      authenticate_auth_token!
    end
  end

  def authenticate_doorkeeper!(*scopes)
    doorkeeper_authorize!(*scopes)
    return if doorkeeper_token.blank?

    @current_user = User.find(doorkeeper_token[:resource_owner_id])
    Sentry.set_user(id: @current_user.id)
  end

  def authenticate_auth_token!
    @current_user = restore_auth_token&.user
    return render_api_error_of :authenticate_failed unless @current_user

    Sentry.set_user(id: @current_user.id)
  end
end
