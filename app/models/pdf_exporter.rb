# frozen_string_literal: true

class PdfExporter
  def initialize(html)
    @html = html
  end

  def export
    file = open_html_temp_file
    file_path = Shellwords.join(['file://', file.path])
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
