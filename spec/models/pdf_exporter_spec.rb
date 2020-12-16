# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PdfExporter, type: :model do
  describe '#export' do
    subject(:pdf) { described_class.new(html).export }

    let(:html) { '<html><body>test</body></html>' }

    it 'export pdf data' do
      expect(pdf).to start_with '%PDF-'
    end
  end
end
