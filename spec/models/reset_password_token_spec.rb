# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PasswordResetToken, type: :model do
  describe '#issue' do
    let(:user) { create(:user) }

    around do |e|
      travel_to('2019-01-01 00:00:00'.to_time) { e.run }
    end

    it 'issue password reset token' do
      PasswordResetToken.issue(user)
      expect(user.password_reset_token).to_not be_nil
    end

    it 'set expired_at correctly' do
      PasswordResetToken.issue(user)
      expect(user.password_reset_token.expired_at).to eq('2019-01-01 00:05:00')
    end

    it 'returns raw' do
      raw = PasswordResetToken.issue(user)
      expect(raw).to_not be_nil
    end

    context 'when user already has token' do
      it 'override token' do
        prev = create(:password_reset_token, user: user)
        PasswordResetToken.issue(user)
        expect(prev.token).to_not eq(user.reload.password_reset_token.token)
      end
    end
  end

  describe '#expired?' do
    subject do
      create(:password_reset_token, expired_at: expired_at).expired?
    end

    context 'when token is not expired' do
      let(:expired_at) { Time.now + 1.day }
      it { is_expected.to eq(false) }
    end

    context 'when token was expired' do
      let(:expired_at) { Time.now - 1.day }
      it { is_expected.to eq(true) }
    end
  end

  describe '#==' do
    let(:user) { create(:user) }

    context 'when raw is valid' do
      it 'returns true' do
        raw = PasswordResetToken.issue(user)
        expect(user.password_reset_token).to eq(raw)
      end
    end

    context 'when raw is invalid' do
      it 'returns false' do
        PasswordResetToken.issue(user)
        expect(user.password_reset_token == 'invalid').to eq(false)
      end
    end
  end

  describe '#hash_token' do
    let(:password_reset_token) { create(:password_reset_token) }

    it 'hash token before save' do
      expect(password_reset_token.token).to start_with('$2a$')
    end
  end
end
