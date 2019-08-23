# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefreshToken, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe '#issue' do
    let(:user) { create(:user) }

    it 'issue refresh token' do
      RefreshToken.issue(user)
      expect(user.refresh_tokens.first).to_not be_nil
    end

    it 'returns raw' do
      _, raw = RefreshToken.issue(user)
      expect(raw).to_not be_nil
    end

    it 'returns refresh token' do
      refresh_token, = RefreshToken.issue(user)
      expect(refresh_token).to_not be_nil
    end
  end

  describe '#revoke' do
    let(:now) { Time.now }
    let(:refresh_token) { create(:refresh_token) }

    it 'set revoked at' do
      refresh_token.revoke(now)
      expect(refresh_token.revoked_at).to eq(now)
    end
  end

  describe '#revoked?' do
    let(:refresh_token) { create(:refresh_token, revoked_at: revoked_at) }

    context 'when revoked at is before current time' do
      let(:revoked_at) { Time.now - 1.day }
      it { expect(refresh_token.revoked?).to be_truthy }
    end

    context 'when revoked at is after current time' do
      let(:revoked_at) { Time.now + 1.day }
      it { expect(refresh_token.revoked?).to be_falsy }
    end

    context 'when revoked at is nil' do
      let(:revoked_at) { nil }
      it { expect(refresh_token.revoked?).to be_falsy }
    end
  end

  describe '#fetch' do
    let(:user) { create(:user) }
    let(:issued) { RefreshToken.issue(user) }

    subject { RefreshToken.fetch(client_id: client_id, raw: raw) }

    context 'when client id and raw are valid' do
      let(:refresh_token) { issued[0] }
      let(:client_id) { refresh_token.client_id }
      let(:raw) { issued[1] }
      it { is_expected.to eql(refresh_token) }
    end

    context 'when raw is invalid' do
      let(:client_id) { 'invalid' }
      let(:raw) { issued[1] }
      it { is_expected.to be_nil }
    end

    context 'when refresh token was revoked' do
      let(:refresh_token) { issued[0] }
      let(:client_id) { refresh_token.client_id }
      let(:raw) { issued[1] }
      before { refresh_token.update!(revoked_at: Time.now - 1.day) }
      it { is_expected.to be_nil }
    end

    context 'when client id and raw are invalid' do
      let(:client_id) { 'invalid' }
      let(:raw) { 'invalid' }
      it { is_expected.to be_nil }
    end
  end

  describe '#==' do
    let(:user) { create(:user) }

    context 'when raw is valid' do
      it 'returns true' do
        refresh_token, raw = RefreshToken.issue(user)
        expect(refresh_token == raw).to eq(true)
      end
    end

    context 'when raw is invalid' do
      it 'returns false' do
        refresh_token, = RefreshToken.issue(user)
        expect(refresh_token == 'invalid').to eq(false)
      end
    end
  end

  describe '#hash_token' do
    let(:refresh_token) { create(:refresh_token) }

    it 'hash token before save' do
      expect(refresh_token.token).to start_with('$2a$')
    end
  end
end
