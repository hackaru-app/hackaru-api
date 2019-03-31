# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Webhook, type: :model do
  describe 'validations' do
    subject do
      webhook.valid?
      webhook
    end

    context 'when target_url is empty' do
      let(:webhook) { build(:webhook, target_url: '') }
      it { expect(subject.errors).to be_include :target_url }
    end

    context 'when target_url is invalid' do
      let(:webhook) { build(:webhook, target_url: 'invalid_url') }
      it { expect(subject.errors).to be_include :target_url }
    end

    context 'when target_url and event are reserved' do
      let(:reserved) do
        create(
          :webhook,
          event: 'activity:create',
          target_url: 'http://example.com'
        )
      end

      let(:webhook) do
        build(
          :webhook,
          user: user,
          event: 'activity:create',
          target_url: 'http://example.com'
        )
      end

      context 'when same user' do
        let(:user) { reserved.user }
        it { expect(subject.errors).to be_include :target_url }
      end

      context 'when different user' do
        let(:user) { create(:user) }
        it { is_expected.to be_valid }
      end
    end
  end

  describe '#deliver' do
    let(:webhook) { create(:webhook) }

    it 'delivers webhook with payload' do
      stub = stub_request(:post, webhook.target_url).with(body: 'delivered')
      webhook.deliver('delivered')
      expect(stub).to have_been_requested.times(1)
    end
  end
end
