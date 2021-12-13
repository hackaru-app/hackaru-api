# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportMailerJob::Weekly, type: :model do
  describe '#target_users' do
    subject { described_class.new(today).target_users.size }

    context 'when today and start_day are same wday' do
      let(:today) { Time.zone.local(2021, 1, 3) }

      before do
        create(
          :user,
          receive_week_report: true,
          start_day: 0
        )
      end

      it { is_expected.to eq(1) }
    end

    context 'when today and start_day are not same wday' do
      let(:today) { Time.zone.local(2021, 1, 3) }

      before do
        create(
          :user,
          receive_week_report: true,
          start_day: 1
        )
      end

      it { is_expected.to be_zero }
    end

    context 'when user does not want to receive' do
      let(:today) { Time.zone.local(2021, 1, 3) }

      before do
        create(
          :user,
          receive_week_report: false,
          start_day: 0
        )
      end

      it { is_expected.to be_zero }
    end
  end

  describe '#build_period' do
    subject(:period) do
      described_class.new(today).build_period(user)
    end

    context 'when user has time zone is UTC' do
      let(:today) { Time.zone.local(2021, 1, 3) }

      let(:user) do
        create(
          :user,
          time_zone: 'Etc/UTC',
          start_day: 0
        )
      end

      it 'returns period of previous week' do
        from = Time.zone.local(2020, 12, 27).beginning_of_day
        to = Time.zone.local(2021, 1, 2).end_of_day
        expect(period).to eq(from..to)
      end
    end

    context 'when user has time zone is not UTC' do
      let(:today) { Time.zone.local(2021, 1, 3) }
      let(:time_zone) { 'Asia/Tokyo' }

      let(:user) do
        create(
          :user,
          time_zone: time_zone,
          start_day: 0
        )
      end

      it 'returns period of previous week' do
        from = Time.new(2020, 12, 27).in_time_zone(time_zone).beginning_of_day
        to = Time.new(2021, 1, 2).in_time_zone(time_zone).end_of_day
        expect(period).to eq(from..to)
      end
    end
  end

  describe '#title' do
    subject { described_class.new(Time.zone.local(2021, 1, 3)).title }

    it { is_expected.to eq(I18n.t(:title, scope: 'jobs.report_mailer_job.weekly')) }
  end
end
