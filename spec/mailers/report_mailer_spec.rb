# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportMailer, type: :mailer do
  describe '#report' do
    subject(:mail) do
      range = Time.zone.today.all_week
      described_class.report(
        user,
        'title',
        range.begin,
        range.end
      )
    end

    let(:user) { create(:user) }

    it 'send to user' do
      expect(mail.to.first).to eq(user.email)
    end

    it 'has subject is correctly' do
      expect(mail.subject).to eq 'title'
    end
  end
end
