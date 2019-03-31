# frozen_string_literal: true

class ApplicationController < ActionController::API
  include HttpAcceptLanguage::AutoLocale

  attr_reader :current_user

  def render_exception
    exception = request.env['action_dispatch.exception']
    render_error ExceptionRenderer.new(exception)
  end

  def render_error_by_key(key)
    render_error ErrorRenderer.new(key)
  end

  def render_error(renderer)
    render json: { message: renderer.message }, status: renderer.status
  end

  def authenticate_doorkeeper!(*scopes)
    doorkeeper_authorize!(*scopes)
    return unless doorkeeper_token.present?

    @current_user = User.find(doorkeeper_token[:resource_owner_id])
  end

  def authenticate_user!
    @current_user = AccessToken.verify(request.headers['X-Access-Token'])
    render_error_by_key :access_token_invalid unless @current_user
  end

  def authenticate_user_or_doorkeeper!(*scopes)
    if request.headers['Authorization']
      authenticate_doorkeeper!(*scopes)
    else
      authenticate_user!
    end
  end
end
