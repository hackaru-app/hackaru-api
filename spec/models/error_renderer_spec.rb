# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ErrorRenderer, type: :model do
  describe '#initialize' do
    subject(:instance) { described_class.new(:sign_in_failed) }

    it 'has message correctly' do
      expect(instance.message).to eq 'Invalid email or password.'
    end

    it 'has status correctly' do
      expect(instance.status).to eq 400
    end
  end
end
