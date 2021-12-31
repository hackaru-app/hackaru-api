# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MixpanelUrlHelper, type: :helper do
  include described_class

  describe '#mixpanel_pixel_url' do
    context 'with props' do
      subject do
        mixpanel_pixel_url('event', { example: 'example' })
      end

      let(:data) do
        Base64.urlsafe_encode64({
          event: 'event',
          properties: {
            example: 'example',
            token: 'token',
            repository: 'hackaru-api'
          }
        }.to_json)
      end

      let(:query) do
        URI.encode_www_form({ data: data, img: 1 })
      end

      it { is_expected.to eq "https://api.mixpanel.com/track?#{query}" }
    end

    context 'without props' do
      subject do
        mixpanel_pixel_url('event', {})
      end

      let(:data) do
        Base64.urlsafe_encode64({
          event: 'event',
          properties: {
            token: 'token',
            repository: 'hackaru-api'
          }
        }.to_json)
      end

      let(:query) do
        URI.encode_www_form({ data: data, img: 1 })
      end

      it { is_expected.to eq "https://api.mixpanel.com/track?#{query}" }
    end
  end
end
