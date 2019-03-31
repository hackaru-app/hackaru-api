# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject do
      user.valid?
      user
    end

    context 'when email is empty' do
      let(:user) { build(:user, email: '') }
      it { expect(subject.errors).to be_include :email }
    end

    context 'when email is invalid' do
      let(:user) { build(:user, email: 'yay') }
      it { expect(subject.errors).to be_include :email }
    end

    context 'when email is reserved' do
      let(:user) { create(:user) }
      let(:user) { build(:user, email: 'foo@bar.com') }
      before { create(:user, email: 'foo@bar.com') }
      it { expect(subject.errors).to be_include :email }
    end

    context 'when password is empty' do
      let(:user) { build(:user, password: '') }
      it { expect(subject.errors).to be_include :password }
    end

    context 'when password is nil' do
      let(:user) { build(:user, password: nil) }
      it { expect(subject.errors).to be_include :password }
    end

    context 'when password is too short' do
      let(:user) { build(:user, password: 'abcde') }
      it { expect(subject.errors).to be_include :password }
    end

    context 'when password is too long' do
      let(:user) { build(:user, password: 'a' * 51) }
      it { expect(subject.errors).to be_include :password }
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
        success = user.reset_password('secret', 'changed', 'changed')
        expect(user.password).to eq('changed')
        expect(success).to eq(true)
      end
    end

    context 'raw token is invalid' do
      it 'does not change password' do
        success = user.reset_password('invalid', 'changed', 'changed')
        expect(user.password).to eq('unchanged')
        expect(success).to eq(false)
      end
    end

    context 'token was expired' do
      let(:expired_at) { Time.now - 1.day }

      it 'does not change password' do
        success = user.reset_password('secret', 'changed', 'changed')
        expect(user.password).to eq('unchanged')
        expect(success).to eq(false)
      end
    end

    context 'password and password confirmation are not same' do
      it 'does not change password' do
        expect { user.reset_password('secret', 'in', 'valid') }
          .to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end
