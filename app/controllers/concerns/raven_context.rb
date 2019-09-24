# frozen_string_literal: true

module RavenContext
  private

  def set_raven_context
    Raven.user_context(id: @current_user.id) if @current_user
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
