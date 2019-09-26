# frozen_string_literal: true

module RavenExtraContext
  extend ActiveSupport::Concern

  included do
    before_action :set_raven_extra_context
  end

  private

  def set_raven_extra_context
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
