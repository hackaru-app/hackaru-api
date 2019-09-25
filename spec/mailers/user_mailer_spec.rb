# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe '#password_reset' do
    let(:user) { create(:user) }
    subject { UserMailer.password_reset(user) }

    it 'send to user' do
      expect(subject.to.first).to eq(user.email)
    end

    describe 'text' do
      it 'has password-reset url in body' do
        path = "#{ENV.fetch('HACKARU_WEB_URL')}/password-reset/edit"
        query = "token=.+&user_id=#{user.id}"
        expect(subject.parts[0].body).to match(/#{path}\?#{query}/)
      end
    end

    describe 'html' do
      it 'has password-reset url in body' do
        path = "#{ENV.fetch('HACKARU_WEB_URL')}/password-reset/edit"
        query = "token=.+&amp;user_id=#{user.id}"
        expect(subject.parts[1].body.raw_source).to match(/#{path}\?#{query}/)
      end
    end
  end
end
