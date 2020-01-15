# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_one(:password_reset_token).dependent(:delete) }
    it { is_expected.to have_one(:user_setting).dependent(:delete) }
    it { is_expected.to have_many(:projects).dependent(:delete_all) }
    it { is_expected.to have_many(:activities).dependent(:delete_all) }
    it { is_expected.to have_many(:refresh_tokens).dependent(:delete_all) }
    it { is_expected.to have_many(:webhooks).dependent(:delete_all) }
  end

  describe 'validations' do
    subject { build(:user) }

    describe 'user_setting' do
      it { is_expected.to validate_presence_of(:user_setting) }
    end

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
  end

  describe '#destroy' do
    before { user.destroy! }

    context 'when user has any activity' do
      let(:user) { create(:activity).user }
      it { expect(User.exists?(id: user.id)).to be_falsey }
    end

    context 'when user has any project' do
      let(:user) { create(:project).user }
      it { expect(User.exists?(id: user.id)).to be_falsey }
    end

    context 'when user has any password_reset_token' do
      let(:user) { create(:password_reset_token).user }
      it { expect(User.exists?(id: user.id)).to be_falsey }
    end

    context 'when user has any refresh_token' do
      let(:user) { create(:refresh_token).user }
      it { expect(User.exists?(id: user.id)).to be_falsey }
    end

    context 'when user has any webhook' do
      let(:user) { create(:webhook).user }
      it { expect(User.exists?(id: user.id)).to be_falsey }
    end
  end

  describe '#reset_password' do
    let(:user) { create(:user, password: 'unchanged') }
    let(:expired_at) { Time.now + 1.day }

    before do
      create(
        :password_reset_token,
        user: user,
        expired_at: expired_at,
        token: 'secret'
      )
    end

    context 'raw token and password are valid' do
      it 'change password' do
        success = user.reset_password(
          token: 'secret',
          password: 'changed',
          password_confirmation: 'changed'
        )
        expect(user.password).to eq('changed')
        expect(success).to eq(true)
      end
    end

    context 'raw token is invalid' do
      it 'does not change password' do
        success = user.reset_password(
          token: 'invalid',
          password: 'changed',
          password_confirmation: 'changed'
        )
        expect(user.password).to eq('unchanged')
        expect(success).to eq(false)
      end
    end

    context 'token was expired' do
      let(:expired_at) { Time.now - 1.day }

      it 'does not change password' do
        success = user.reset_password(
          token: 'secret',
          password: 'changed',
          password_confirmation: 'changed'
        )
        expect(user.password).to eq('unchanged')
        expect(success).to eq(false)
      end
    end

    context 'password and password confirmation are not same' do
      it 'does not change password' do
        expect do
          user.reset_password(
            token: 'secret',
            password: 'in',
            password_confirmation: 'valid'
          )
        end.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe '#add_sample_projects' do
    let(:user) { build(:user) }
    before { user.add_sample_projects }

    it 'add sample projects' do
      expect(user.projects.size).to eq(3)
    end
  end
end
