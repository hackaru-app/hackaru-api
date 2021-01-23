# frozen_string_literal: true

module ErrorRenderable
  def render_exception
    exception = request.env['action_dispatch.exception']
    render_error_from_renderer ExceptionRenderer.new(exception)
  end

  def render_error_by_key(key)
    render_error_from_renderer ErrorRenderer.new(key)
  end

  def render_error_from_renderer(renderer)
    render json: { message: renderer.message }, status: renderer.status
  end
end
