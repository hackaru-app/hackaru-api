# frozen_string_literal: true

require 'open3'

class PdfExporter
  def initialize(html)
    @html = html
  end

  def export
    file = open_html_temp_file
    file_path = URI.join('file://', file.path).to_s
    pdf_data, = Open3.capture3('scripts/pdf.js', file_path)
    file.unlink
    pdf_data
  end

  private

  def open_html_temp_file
    Tempfile.open(['pdf_exporter', '.html']) do |f|
      f.write @html
      f
    end
  end
end
