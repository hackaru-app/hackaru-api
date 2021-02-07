# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_one(:password_reset_token).dependent(:delete) }
    it { is_expected.to have_many(:projects).dependent(:delete_all) }
    it { is_expected.to have_many(:activities).dependent(:delete_all) }
    it { is_expected.to have_many(:auth_tokens).dependent(:delete_all) }
  end

  describe 'validations' do
    subject { build(:user) }

    describe 'email' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_uniqueness_of(:email) }
      it { is_expected.to validate_length_of(:email).is_at_most(191) }
      it { is_expected.to allow_value('example@example.com').for(:email) }
      it { is_expected.not_to allow_value('invalid').for(:email) }
    end

    describe 'password' do
      it { is_expected.to have_secure_password }
      it { is_expected.to validate_length_of(:password).is_at_least(6) }
      it { is_expected.to validate_length_of(:password).is_at_most(50) }
    end

    describe 'time_zone' do
      let(:mapping) { ActiveSupport::TimeZone::MAPPING.values }

      it { is_expected.to validate_inclusion_of(:time_zone).in_array(mapping) }
    end

    describe 'locale' do
      let(:array) { I18n.available_locales.map(&:to_s) }

      it { is_expected.to validate_inclusion_of(:locale).in_array(array) }
    end
  end

  describe '#destroy' do
    before { user.destroy! }

    context 'when user has any activity' do
      let(:user) { create(:activity).user }

      it { expect(described_class).not_to exist(id: user.id) }
    end

    context 'when user has any project' do
      let(:user) { create(:project).user }

      it { expect(described_class).not_to exist(id: user.id) }
    end

    context 'when user has any password_reset_token' do
      let(:user) { create(:password_reset_token).user }

      it { expect(described_class).not_to exist(id: user.id) }
    end

    context 'when user has any auth_token' do
      let(:user) { create(:auth_token).user }

      it { expect(described_class).not_to exist(id: user.id) }
    end
  end

  describe '#reset_password' do
    let(:user) { create(:user, password: 'unchanged') }
    let(:expired_at) { Time.zone.now + 1.day }

    before do
      create(
        :password_reset_token,
        user: user,
        expired_at: expired_at,
        token: 'secret'
      )
    end

    context 'when raw token and password are valid' do
      let(:args) do
        {
          token: 'secret',
          password: 'changed',
          password_confirmation: 'changed'
        }
      end

      it 'changes password' do
        user.reset_password(**args)
        expect(user.password).to eq('changed')
      end

      it 'returns true' do
        expect(user.reset_password(**args)).to eq(true)
      end
    end

    context 'when raw token is invalid' do
      let(:args) do
        {
          token: 'invalid',
          password: 'changed',
          password_confirmation: 'changed'
        }
      end

      it 'does not change password' do
        user.reset_password(**args)
        expect(user.password).to eq('unchanged')
      end

      it 'returns false' do
        expect(user.reset_password(**args)).to eq(false)
      end
    end

    context 'when token was expired' do
      let(:expired_at) { Time.zone.now - 1.day }

      let(:args) do
        {
          token: 'secret',
          password: 'changed',
          password_confirmation: 'changed'
        }
      end

      it 'does not change password' do
        user.reset_password(**args)
        expect(user.password).to eq('unchanged')
      end

      it 'returns false' do
        expect(user.reset_password(**args)).to eq(false)
      end
    end

    context 'when password and password confirmation are not same' do
      let(:args) do
        {
          token: 'secret',
          password: 'in',
          password_confirmation: 'valid'
        }
      end

      it 'raises error' do
        expect { user.reset_password(**args) }
          .to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end
