# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityCalendar, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:activities).through(:user) }
  end

  describe '#to_ical' do
    subject { create(:activity_calendar, user: user).to_ical }

    context 'when user has activities' do
      let(:activity) { create(:activity) }
      let(:user) { activity.user }

      it 'has event' do
        dtstart = activity.started_at.strftime('%Y%m%dT%H%M%S')
        dtend = activity.stopped_at.strftime('%Y%m%dT%H%M%S')
        is_expected.to be_include "SUMMARY:#{activity.description}"
        is_expected.to be_include "DTSTART:#{dtstart}"
        is_expected.to be_include "DTEND:#{dtend}"
      end
    end

    context 'when user has activities but activity is not stopped' do
      let(:activity) { create(:activity, stopped_at: nil) }
      let(:user) { activity.user }
      it { is_expected.not_to be_include 'BEGIN:VEVENT' }
    end

    context 'when user does not have activities' do
      let(:user) { create(:user) }
      it { is_expected.not_to be_include 'BEGIN:VEVENT' }
    end
  end
end
