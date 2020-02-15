# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportMailer, type: :mailer do
  describe '#report' do
    let(:user) { create(:user) }

    subject do
      range = Date.today.all_week
      ReportMailer.report(
        user,
        'title',
        range.begin,
        range.end
      )
    end

    it 'send to user' do
      expect(subject.to.first).to eq(user.email)
    end

    it 'has subject is correctly' do
      expect(subject.subject).to eq 'title'
    end
  end
end
