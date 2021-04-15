# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClosestTimeZoneFinder, type: :model do
  describe '#find' do
    subject(:found) do
      instance.find
    end

    let(:instance) { described_class.new(time_zone) }

    context 'when active_support has this time_zone in mapping' do
      let(:time_zone) { 'Asia/Tokyo' }

      it { is_expected.to eq('Asia/Tokyo') }
    end

    context 'when active_support does not have this time_zone in mapping' do
      let(:time_zone) { 'America/Vancouver' }

      it { is_expected.to eq('America/Los_Angeles') }
    end

    context 'when time_zone is invalid' do
      let(:time_zone) { 'invalid' }

      it 'raises error' do
        expect { instance.find }
          .to raise_error TZInfo::InvalidTimezoneIdentifier
      end
    end

    context 'when time_zone is nil' do
      let(:time_zone) { nil }

      it 'raises error' do
        expect { instance.find }
          .to raise_error TZInfo::InvalidTimezoneIdentifier
      end
    end
  end
end
