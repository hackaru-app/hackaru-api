# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReminderMailer, type: :mailer do
  describe '#report' do
    let(:user) { create(:user) }
    let(:activity) { create(:activity, user: user) }

    subject do
      ReminderMailer.remind(user, activity)
    end

    it 'send to user' do
      expect(subject.to.first).to eq(user.email)
    end
  end
end
