# frozen_string_literal: true

module PdfRenderable
  extend ActiveSupport::Concern

  private

  def render_pdf(action)
    html = render_to_string(action, formats: [:html], layout: 'pdf')
    send_data(PdfExporter.new(html).export, type: 'application/pdf')
  end
end
