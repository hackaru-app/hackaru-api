# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PasswordResetToken, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe '#issue' do
    let(:user) { create(:user) }

    around do |e|
      travel_to('2019-01-01 00:00:00') { e.run }
    end

    it 'issues password reset token' do
      described_class.issue(user)
      expect(user.password_reset_token).not_to be_nil
    end

    it 'sets expired_at correctly' do
      described_class.issue(user)
      expect(user.password_reset_token.expired_at).to eq('2019-01-01 00:05:00')
    end

    it 'returns raw' do
      raw = described_class.issue(user)
      expect(raw).not_to be_nil
    end

    context 'when user already has token' do
      it 'override token' do
        prev = create(:password_reset_token, user: user)
        described_class.issue(user)
        expect(prev.token).not_to eq(user.reload.password_reset_token.token)
      end
    end
  end

  describe '#expired?' do
    subject do
      create(:password_reset_token, expired_at: expired_at).expired?
    end

    context 'when token is not expired' do
      let(:expired_at) { Time.zone.now + 1.day }

      it { is_expected.to eq(false) }
    end

    context 'when token was expired' do
      let(:expired_at) { Time.zone.now - 1.day }

      it { is_expected.to eq(true) }
    end
  end

  describe '#==' do
    let(:user) { create(:user) }

    context 'when raw is valid' do
      it 'returns true' do
        raw = described_class.issue(user)
        expect(user.password_reset_token).to eq(raw)
      end
    end

    context 'when raw is invalid' do
      it 'returns false' do
        described_class.issue(user)
        expect(user.password_reset_token == 'invalid').to eq(false)
      end
    end
  end

  describe '#hash_token' do
    let(:password_reset_token) { create(:password_reset_token) }

    it 'hashes token before save' do
      expect(password_reset_token.token).to start_with('$2a$')
    end
  end
end
