# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebpackUrlHelper, type: :helper do
  include described_class

  describe '#webpack_url' do
    subject { webpack_url(path) }

    let(:manifest) do
      { 'example.js' => '/packs/example.js' }
    end

    before do
      allow(self).to receive(:compute_asset_host).and_return('http://localhost/')
      allow(self).to receive(:manifest).and_return(manifest)
    end

    context 'when path exists' do
      let(:path) { 'example.js' }

      it { is_expected.to eq 'http://localhost/packs/example.js' }
    end

    context 'when path does not exist' do
      let(:path) { 'invalid.js' }

      it 'raises error' do
        expect { webpack_url(path) }.to raise_error KeyError
      end
    end
  end
end
