# frozen_string_literal: true

class ExceptionsController < ActionController::API
  include ApiErrorRenderable

  def show
    exception = request.env['action_dispatch.exception']
    render_api_error ApiExceptionError.new(exception)
  end
end
