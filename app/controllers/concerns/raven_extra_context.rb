# frozen_string_literal: true

module RavenExtraContext
  private

  def set_raven_extra_context
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
