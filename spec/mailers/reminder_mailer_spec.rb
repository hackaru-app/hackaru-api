# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReminderMailer, type: :mailer do
  describe '#report' do
    let(:user) { create(:user) }
    let(:activities) { create_list(:activity, 2, user: user) }

    subject do
      ReminderMailer.remind(user, activities)
    end

    it 'send to user' do
      expect(subject.to.first).to eq(user.email)
    end
  end
end
