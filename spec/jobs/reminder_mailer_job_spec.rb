# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReminderMailerJob, type: :job do
  describe '#perform' do
    subject do
      ActionMailer::Base.deliveries
    end

    after do
      ActionMailer::Base.deliveries.clear
    end

    context 'target activities is present' do
      let!(:user) { create(:user, receive_reminder: true) }
      let!(:activity) do
        create(
          :activity,
          user: user,
          stopped_at: nil,
          reminded: false,
          started_at: 5.hours.ago
        )
      end

      before do
        perform_enqueued_jobs do
          described_class.new.perform
        end
      end

      it 'send mail to user' do
        expect(subject.size).to eq(1)
        expect(subject.last.to.first).to eq(user.email)
      end

      it 'activity.reminded changes to true' do
        expect(activity.reload.reminded).to eq(true)
      end
    end

    context 'target activities is blank' do
      before do
        perform_enqueued_jobs do
          described_class.new.perform
        end
      end

      it 'does not send mail to user' do
        expect(subject.size).to eq(0)
      end
    end
  end
end
