# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PdfExporter, type: :model do
  describe '#export' do
    let(:html) { '<html><body>test</body></html>' }
    subject { PdfExporter.new(html).export }

    it 'export pdf data' do
      is_expected.to start_with '%PDF-'
    end
  end
end
