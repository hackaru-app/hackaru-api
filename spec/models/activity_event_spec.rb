# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityEvent, type: :model do
  describe '#event' do
    let(:activity) { create(:activity) }
    subject { ActivityEvent.new(activity).event }

    it 'has dtstart' do
      datetime = activity.started_at.strftime('%Y%m%dT%H%M%SZ')
      expect(subject.dtstart.value_ical).to eq datetime
    end

    it 'has dtend' do
      datetime = activity.stopped_at.strftime('%Y%m%dT%H%M%SZ')
      expect(subject.dtend.value_ical).to eq datetime
    end

    it 'has summary' do
      expect(subject.summary.value_ical).to eq activity.description
    end

    context 'when activity does not have description' do
      let(:activity) { create(:activity, description: '') }
      it { expect(subject.summary).to eq activity.project.name }
    end

    context 'when activity does not have description and project' do
      let(:activity) { create(:activity, description: '', project: nil) }
      it { expect(subject.summary).to eq 'No Project' }
    end

    context 'when activity is not stopped' do
      let(:activity) { create(:activity, stopped_at: nil) }
      it { expect(subject).to be_nil }
    end
  end
end
