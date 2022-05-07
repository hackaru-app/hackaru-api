# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityCalendar, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:activities).through(:user) }
  end

  describe '#to_ical' do
    subject(:ical) { create(:activity_calendar, user: user).to_ical(limit: 10) }

    context 'when user has activities' do
      let(:activity) { create(:activity) }
      let(:user) { activity.user }

      it 'has summary' do
        expect(ical).to be_include "SUMMARY:#{activity.description}"
      end

      it 'has dtstart' do
        dtstart = activity.started_at.strftime('%Y%m%dT%H%M%S')
        expect(ical).to be_include "DTSTART:#{dtstart}"
      end

      it 'has dtend' do
        dtend = activity.stopped_at.strftime('%Y%m%dT%H%M%S')
        expect(ical).to be_include "DTEND:#{dtend}"
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

    context 'when the user has more activities than the limit' do
      let(:user) { create(:user) }

      before { create_list(:activity, 20, user: user) }

      it { expect(ical.scan('DTSTART').count).to eq(10) }
    end

    context 'when multiple users have activities' do
      let(:activities) { create_list(:activity, 2) }
      let(:user) { activities[0].user }

      it 'has summary the current user has' do
        expect(ical).to be_include "SUMMARY:#{activities[0].description}"
      end

      it 'does not have summary other users has' do
        expect(ical).not_to be_include "SUMMARY:#{activities[1].description}"
      end
    end
  end
end
