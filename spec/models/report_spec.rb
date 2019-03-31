# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  describe '#summary' do
    let(:now) { Time.parse('2019-01-01T01:23:45') }
    let(:project) { create(:project, user: user) }
    let(:user) { create(:user) }
    let(:time_zone) { nil }

    subject do
      Report.new(user, range, period, time_zone).summary
    end

    context 'when period is hour' do
      let(:range) { (now - 2.hours)..now }
      let(:period) { 'hour' }

      before do
        create(
          :activity,
          user: user,
          project: project,
          started_at: now - 1.hour,
          stopped_at: now
        )
      end

      it 'returns summary correctly' do
        expect(subject).to eq(
          [project.id, Time.parse('2018-12-31T23:00:00.000Z')] => 0,
          [project.id, Time.parse('2019-01-01T00:00:00.000Z')] => 3600,
          [project.id, Time.parse('2019-01-01T01:00:00.000Z')] => 0
        )
      end
    end

    context 'when period is day' do
      let(:range) { (now - 2.days)..now }
      let(:period) { 'day' }

      before do
        create(
          :activity,
          user: user,
          project: project,
          started_at: now - 1.day,
          stopped_at: now
        )
      end

      it 'returns summary correctly' do
        expect(subject).to eq(
          [project.id, Date.parse('2018-12-30')] => 0,
          [project.id, Date.parse('2018-12-31')] => 86_400,
          [project.id, Date.parse('2019-01-01')] => 0
        )
      end
    end

    context 'when period is month' do
      let(:range) { (now - 2.months)..now }
      let(:period) { 'month' }

      before do
        create(
          :activity,
          user: user,
          project: project,
          started_at: now - 1.month,
          stopped_at: now
        )
      end

      it 'returns summary correctly' do
        expect(subject).to eq(
          [project.id, Date.parse('2018-11-01')] => 0,
          [project.id, Date.parse('2018-12-01')] => 2_678_400,
          [project.id, Date.parse('2019-01-01')] => 0
        )
      end
    end

    context 'when time_zone is defined' do
      let(:time_zone) { 'Asia/Tokyo' } # +09:00
      let(:range) { (now - 1.day)..now }
      let(:period) { 'day' }

      before do
        create(
          :activity,
          user: user,
          project: project,
          started_at: Time.parse('2018-12-31T22:00:00'),
          stopped_at: Time.parse('2018-12-31T23:00:00')
        )
      end

      it 'returns summary correctly' do
        expect(subject).to eq(
          [project.id, Date.parse('2018-12-31')] => 0,
          [project.id, Date.parse('2019-01-01')] => 3600
        )
      end
    end

    context 'when result is empty' do
      let(:range) { (now - 1.day)..now }
      let(:period) { 'day' }

      it 'returns empty' do
        expect(subject).to eq({})
      end
    end
  end
end
