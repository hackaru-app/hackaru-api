# frozen_string_literal: true

module V1
  class ReportsController < ApplicationController
    include ActionView::Rendering

    def show
      render_pdf :show
    end

    private

    def render_temp_file(action)
      Tempfile.open(['pdf', '.html']) do |f|
        f.write render_to_string(action, formats: [:html])
        f
      end
    end

    def render_pdf(action)
      file = render_temp_file(action)
      pdf_data, = Open3.capture3('scripts/pdf.js', "file://#{file.path}")
      send_data(pdf_data, type: 'application/pdf')
      file.unlink
    end
  end
end
