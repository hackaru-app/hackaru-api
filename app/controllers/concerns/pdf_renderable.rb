# frozen_string_literal: true

module PdfRenderable
  extend ActiveSupport::Concern

  include ActionView::Layouts
  include ActionController::Rendering

  private

  def render_pdf(action)
    html = render_to_string(action, formats: [:html], layout: 'pdf')
    send_data(PdfExporter.new(html).export, type: 'application/pdf')
  end

  # https://github.com/rails/rails/issues/27211#issuecomment-264392054
  def render_to_body(options)
    _render_to_body_with_renderer(options) || super
  end
end
