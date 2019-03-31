# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe '#password_reset' do
    let(:user) { create(:user) }
    subject { UserMailer.password_reset(user) }

    it 'send to user' do
      expect(subject.to.first).to eq(user.email)
    end

    it 'has url in body' do
      path = "#{ENV.fetch('HACKARU_WEB_URL')}/password-reset/edit"
      query = "token=.+&user_id=#{user.id}"
      expect(subject.body).to match(/#{path}\?#{query}/)
    end
  end
end
