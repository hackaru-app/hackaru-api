# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailHelper, type: :helper do
  before do
    class MockMailer < ActionMailer::Base
      include EmailHelper
    end
  end

  describe '#utm_url' do
    subject { helper.utm_url url }

    before do
      allow(helper).to receive(:controller_path).and_return(:controller_path)
      allow(helper).to receive(:action_name).and_return(:action_name)
    end

    context 'when url does not have query' do
      let(:url) { 'http://example.com' }
      it 'returns url correctly' do
        expect(subject).to eq(
          'http://example.com?utm_medium=email&utm_source=controller_path&utm_campaign=action_name'
        )
      end
    end

    context 'when url has query' do
      let(:url) { 'http://example.com?a=b' }
      it 'does not overwrite query' do
        expect(subject).to eq(
          'http://example.com?a=b&utm_medium=email&utm_source=controller_path&utm_campaign=action_name'
        )
      end
    end
  end
end
