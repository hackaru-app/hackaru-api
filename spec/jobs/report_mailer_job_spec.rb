# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportMailerJob, type: :job do
  describe '#perform' do
    subject do
      ActionMailer::Base.deliveries
    end

    after do
      ActionMailer::Base.deliveries.clear
    end

    around do |e|
      travel_to('2017-01-08 00:00:00'.to_time) { e.run }
    end

    context 'when period is week' do
      let(:args) { [{ 'period' => 'week' }] }
      let(:user) { create(:user, receive_week_report: true) }

      before do
        create(
          :activity,
          user: user,
          started_at: Date.new(2017, 1, 1),
          stopped_at: Date.new(2017, 1, 2)
        )
        perform_enqueued_jobs do
          ReportMailerJob.new.perform(*args)
        end
      end

      it 'send mail to user' do
        expect(subject.size).to eq(1)
        expect(subject.last.to.first).to eq(user.email)
      end
    end

    context 'when period is week but user does not have activities in range' do
      let(:user) { create(:user, receive_week_report: true) }
      let(:args) { [{ 'period' => 'week' }] }

      before do
        create(
          :activity,
          user: user,
          started_at: Date.new(2017, 1, 8),
          stopped_at: Date.new(2017, 1, 9)
        )
        create(
          :activity,
          user: user,
          started_at: Date.new(2016, 12, 30),
          stopped_at: Date.new(2017, 12, 31)
        )
        perform_enqueued_jobs do
          ReportMailerJob.new.perform(*args)
        end
      end

      it 'does not send mail to user' do
        expect(subject.size).to be_zero
      end
    end

    context 'when period is month but user does not have activities in range' do
      let(:args) { [{ 'period' => 'week' }] }
      let(:user) { create(:user, receive_week_report: false) }

      before do
        create(
          :activity,
          user: user,
          started_at: Date.new(2016, 11, 29),
          stopped_at: Date.new(2016, 11, 30)
        )
        create(
          :activity,
          user: user,
          started_at: Date.new(2017, 1, 1),
          stopped_at: Date.new(2017, 1, 2)
        )
        perform_enqueued_jobs do
          ReportMailerJob.new.perform(*args)
        end
      end

      it 'does not send mail to user' do
        expect(subject.size).to be_zero
      end
    end

    context 'when period is month but user does not want receive' do
      let(:args) { [{ 'period' => 'month' }] }
      let(:user) { create(:user, receive_month_report: false) }

      before do
        create(
          :activity,
          user: user,
          started_at: Date.new(2017, 1, 1),
          stopped_at: Date.new(2017, 1, 2)
        )
        perform_enqueued_jobs do
          ReportMailerJob.new.perform(*args)
        end
      end

      it 'does not send mail to user' do
        expect(subject.size).to be_zero
      end
    end

    context 'when period is month' do
      let(:args) { [{ 'period' => 'month' }] }
      let(:user) { create(:user, receive_month_report: true) }

      before do
        create(
          :activity,
          user: user,
          started_at: Date.new(2016, 12, 1),
          stopped_at: Date.new(2016, 12, 2)
        )
        perform_enqueued_jobs do
          ReportMailerJob.new.perform(*args)
        end
      end

      it 'send mail to user' do
        expect(subject.size).to eq(1)
        expect(subject.last.to.first).to eq(user.email)
      end
    end

    context 'when target user is multiple' do
      let(:args) { [{ 'period' => 'week' }] }
      let(:users) { create_list(:user, 2, receive_week_report: true) }

      before do
        create(
          :activity,
          user: users[0],
          started_at: Date.new(2017, 1, 1),
          stopped_at: Date.new(2017, 1, 2)
        )
        create(
          :activity,
          user: users[1],
          started_at: Date.new(2017, 1, 1),
          stopped_at: Date.new(2017, 1, 2)
        )
        perform_enqueued_jobs do
          ReportMailerJob.new.perform(*args)
        end
      end

      it 'send mails to users' do
        expect(subject.size).to eq(2)
        expect(subject[0].to.first).to eq(users[0].email)
        expect(subject[1].to.first).to eq(users[1].email)
      end
    end

    context 'when user does not have activities' do
      let(:user) { create(:user, receive_week_report: true) }
      let(:args) { [{ 'period' => 'week' }] }

      before do
        perform_enqueued_jobs do
          ReportMailerJob.new.perform(*args)
        end
      end

      it 'does not send mail to user' do
        expect(subject.size).to be_zero
      end
    end

    context 'when user has activities but working' do
      let(:user) { create(:user, receive_week_report: true) }
      let(:args) { [{ 'period' => 'week' }] }

      before do
        create(
          :activity,
          user: user,
          started_at: Date.new(2017, 1, 1),
          stopped_at: nil
        )
        perform_enqueued_jobs do
          ReportMailerJob.new.perform(*args)
        end
      end

      it 'does not send mail to user' do
        expect(subject.size).to be_zero
      end
    end
  end
end
