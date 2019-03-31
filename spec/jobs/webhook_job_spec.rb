# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhookJob, type: :job do
  describe '#perform' do
    let(:webhook) { create(:webhook) }

    it 'delivers webhook with payload' do
      stub = stub_request(:post, webhook.target_url).with(body: 'delivered')
      WebhookJob.new.perform(webhook.id, 'delivered')
      expect(stub).to have_been_requested.times(1)
    end
  end
end
