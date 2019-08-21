# frozen_string_literal: true

module ErrorRenderable
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
end
