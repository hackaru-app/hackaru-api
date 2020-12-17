# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  describe '#issue' do
    subject(:decoded_token) do
      jwt = described_class.new(user: user, exp: 3600).issue
      JWT.decode(jwt, 'secret', false)
    end

    let(:user) { create(:user) }

    it 'has user id in data' do
      expect(decoded_token[0]['data']['id']).to eq(user.id)
    end

    it 'has user email in data' do
      expect(decoded_token[0]['data']['email']).to eq(user.email)
    end

    it 'use HS256 algorithm' do
      expect(decoded_token[1]['alg']).to eq('HS256')
    end
  end

  describe '#verify' do
    let(:user) { create(:user) }
    let(:alg) { 'HS256' }
    let(:exp) { Time.now.to_i }
    let(:data) { { id: user.id, email: user.email } }

    let(:jwt) do
      secret = ENV.fetch('JWT_SECRET', Rails.application.secret_key_base)
      JWT.encode({ data: data, exp: exp }, secret, alg)
    end

    context 'when jwt is valid' do
      it { expect(described_class.verify(jwt)).to eq(user) }
    end

    context 'when jwt is invalid' do
      let(:jwt) { 'invalid' }

      it { expect(described_class.verify(jwt)).to be_nil }
    end

    context 'when user was deleted' do
      before { user.destroy! }

      it { expect(described_class.verify(jwt)).to be_nil }
    end

    context 'when user email was invalid' do
      let(:data) { { id: user.id, email: 'invalid' } }

      it { expect(described_class.verify(jwt)).to be_nil }
    end

    context 'when user id was invalid' do
      let(:data) { { id: 'invalid', email: user.email } }

      it { expect(described_class.verify(jwt)).to be_nil }
    end

    context 'when data is nil' do
      let(:data) { nil }

      it { expect(described_class.verify(jwt)).to be_nil }
    end

    context 'when jwt was expired' do
      let(:exp) { Time.now.to_i - 3600 }

      it { expect(described_class.verify(jwt)).to be_nil }
    end

    context 'when jwt was expired but exp has leeway' do
      let(:exp) { Time.now.to_i - 10 }

      it { expect(described_class.verify(jwt)).to eq(user) }
    end

    context 'when alg is none' do
      let(:alg) { 'none' }

      it { expect(described_class.verify(jwt)).to be_nil }
    end
  end
end
