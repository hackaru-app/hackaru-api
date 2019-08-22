# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  describe '#issue' do
    let(:user) { create(:user) }

    subject do
      jwt = AccessToken.new(user: user, exp: 3600).issue
      JWT.decode(jwt, 'secret', false)
    end

    it 'has user id in data' do
      expect(subject[0]['data']['id']).to eq(user.id)
    end

    it 'has user email in data' do
      expect(subject[0]['data']['email']).to eq(user.email)
    end

    it 'use HS256 algorithm' do
      expect(subject[1]['alg']).to eq('HS256')
    end
  end

  describe '#verify' do
    let(:user) { create(:user) }
    let(:alg) { 'HS256' }
    let(:exp) { Time.now.to_i }
    let(:secret) { ENV.fetch('JWT_SECRET', Rails.application.secret_key_base) }
    let(:data) { { id: user.id, email: user.email } }
    let(:jwt) { JWT.encode({ data: data, exp: exp }, secret, alg) }

    context 'when jwt is valid' do
      it { expect(AccessToken.verify(jwt)).to eq(user) }
    end

    context 'when jwt is invalid' do
      let(:jwt) { 'invalid' }
      it { expect(AccessToken.verify(jwt)).to be_nil }
    end

    context 'when user was deleted' do
      before { user.destroy! }
      it { expect(AccessToken.verify(jwt)).to be_nil }
    end

    context 'when user email was invalid' do
      let(:data) { { id: user.id, email: 'invalid' } }
      it { expect(AccessToken.verify(jwt)).to be_nil }
    end

    context 'when user id was invalid' do
      let(:data) { { id: 'invalid', email: user.email } }
      it { expect(AccessToken.verify(jwt)).to be_nil }
    end

    context 'when data is nil' do
      let(:data) { nil }
      it { expect(AccessToken.verify(jwt)).to be_nil }
    end

    context 'when jwt was expired' do
      let(:exp) { Time.now.to_i - 3600 }
      it { expect(AccessToken.verify(jwt)).to be_nil }
    end

    context 'when jwt was expired but exp has leeway' do
      let(:exp) { Time.now.to_i - 10 }
      it { expect(AccessToken.verify(jwt)).to eq(user) }
    end

    context 'when alg is none' do
      let(:alg) { 'none' }
      it { expect(AccessToken.verify(jwt)).to be_nil }
    end
  end
end
