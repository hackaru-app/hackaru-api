
class PdfExporter
  def initialize(html)
    @html = html
  end

  def export
    file = open_html_temp_file
    pdf_data, = Open3.capture3('scripts/pdf.js', "file://#{file.path}")
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