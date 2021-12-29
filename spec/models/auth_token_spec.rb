# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthToken, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe '#revoke' do
    let(:auth_token) { create(:auth_token) }

    around do |e|
      travel_to('2021-01-01 00:00:00') { e.run }
    end

    it 'sets expired_at to current time' do
      auth_token.revoke
      expect(auth_token.expired_at).to eq(Time.zone.now)
    end
  end

  describe '.fetch' do
    subject { described_class.fetch(id, raw) }

    let(:auth_token) { create(:auth_token, token: 'secret') }

    context 'when id and raw are valid' do
      let(:id) { auth_token.id }
      let(:raw) { 'secret' }

      it { is_expected.to eq(auth_token) }
    end

    context 'when id is invalid' do
      let(:id) { 0 }
      let(:raw) { 'secret' }

      it { is_expected.to be_nil }
    end

    context 'when raw is invalid' do
      let(:id) { auth_token.id }
      let(:raw) { 'invalid' }

      it { is_expected.to be_nil }
    end

    context 'when raw is hashed value' do
      let(:id) { auth_token.id }
      let(:raw) { auth_token.token }

      it { is_expected.to be_nil }
    end

    context 'when id and raw are invalid' do
      let(:id) { 0 }
      let(:raw) { 'invalid' }

      it { is_expected.to be_nil }
    end

    context 'when id is nil' do
      let(:id) { nil }
      let(:raw) { 'secret' }

      it { is_expected.to be_nil }
    end

    context 'when raw is nil' do
      let(:id) { auth_token.id }
      let(:raw) { nil }

      it { is_expected.to be_nil }
    end

    context 'when id and raw are nil' do
      let(:id) { nil }
      let(:raw) { nil }

      it { is_expected.to be_nil }
    end

    context 'when auth_token is expired' do
      let(:auth_token) { create(:auth_token, expired_at: 1.day.ago) }
      let(:id) { auth_token.id }
      let(:raw) { 'secret' }

      it { is_expected.to be_nil }
    end
  end

  describe '.issue!' do
    let(:user) { create(:user) }

    it 'issues auth_token' do
      described_class.issue!(user)
      expect(user.auth_tokens.first).not_to be_nil
    end

    it 'returns issued auth_token' do
      auth_token = described_class.issue!(user)[0]
      expect(user.auth_tokens.first).to eq(auth_token)
    end

    it 'returns raw' do
      auth_token, raw = described_class.issue!(user)
      expect(BCrypt::Password.new(auth_token.token)).to eq(raw)
    end
  end

  describe '#hash_token' do
    let(:auth_token) { create(:auth_token, token: 'secret') }

    context 'when auth_token created' do
      it { expect(auth_token.token).to start_with('$2a$') }
      it { expect(BCrypt::Password.new(auth_token.token)).to eq('secret') }
    end

    context 'when auth_token updated' do
      before { auth_token.update!(updated_at: 1.day.from_now) }

      it { expect(auth_token.token).to start_with('$2a$') }
      it { expect(BCrypt::Password.new(auth_token.token)).to eq('secret') }
    end
  end
end
