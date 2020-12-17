# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityEvent, type: :model do
  describe '#event' do
    subject(:event) { described_class.new(activity).event }

    let(:activity) { create(:activity) }

    it 'has dtstart' do
      datetime = activity.started_at.strftime('%Y%m%dT%H%M%SZ')
      expect(event.dtstart.value_ical).to eq datetime
    end

    it 'has dtend' do
      datetime = activity.stopped_at.strftime('%Y%m%dT%H%M%SZ')
      expect(event.dtend.value_ical).to eq datetime
    end

    it 'has summary' do
      expect(event.summary.value_ical).to eq activity.description
    end

    context 'when activity does not have description' do
      let(:activity) { create(:activity, description: '') }

      it { expect(event.summary).to eq activity.project.name }
    end

    context 'when activity does not have description and project' do
      let(:activity) { create(:activity, description: '', project: nil) }

      it { expect(event.summary).to eq 'No Project' }
    end

    context 'when activity is not stopped' do
      let(:activity) { create(:activity, stopped_at: nil) }

      it { expect(event).to be_nil }
    end
  end
end
