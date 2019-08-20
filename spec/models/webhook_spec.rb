# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Webhook, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    subject { build(:webhook) }

    describe 'target_url' do
      it { is_expected.to validate_presence_of(:target_url) }
      it { is_expected.to validate_length_of(:target_url).is_at_most(1000) }
      it { is_expected.to allow_value('http://example.com').for(:target_url) }
      it { is_expected.to allow_value('https://example.com').for(:target_url) }
      it { is_expected.not_to allow_value('invalid').for(:target_url) }

      it 'validate uniqueness' do
        scope = %i[user_id event]
        is_expected.to validate_uniqueness_of(:target_url).scoped_to(scope)
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
