# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReminderMailer, type: :mailer do
  describe '#report' do
    let(:activity) { create(:activity) }

    subject do
      ReminderMailer.remind(activity)
    end

    it 'send to user' do
      expect(subject.to.first).to eq(activity.user.email)
    end
  end
end
