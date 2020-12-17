# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReminderMailer, type: :mailer do
  describe '#report' do
    subject(:mail) do
      described_class.remind(user, activity)
    end

    let(:user) { create(:user) }
    let(:activity) { create(:activity, user: user) }

    it 'sends to user' do
      expect(mail.to.first).to eq(user.email)
    end
  end
end
