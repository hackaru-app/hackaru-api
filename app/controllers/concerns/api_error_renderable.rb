# frozen_string_literal: true

module ApiErrorRenderable
  private

  def render_api_error_of(key)
    render_api_error ApiError.new(key)
  end

  def render_api_error(api_error)
    render json: { message: api_error.message }, status: api_error.status
  end
end
