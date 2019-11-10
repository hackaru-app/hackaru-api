# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DurationHelper, type: :helper do
  include DurationHelper

  describe '#hhmmss' do
    subject { hhmmss(value) }

    context 'when value is not zero' do
      let(:value) { 120_131 }
      it { is_expected.to eq '33:22:11' }
    end

    context 'when value is zero' do
      let(:value) { 0 }
      it { is_expected.to eq '00:00:00' }
    end
  end
end
