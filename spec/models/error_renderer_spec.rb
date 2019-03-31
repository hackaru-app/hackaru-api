# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ErrorRenderer, type: :model do
  describe '#initialize' do
    subject { ErrorRenderer.new(:sign_in_failed) }

    it 'has message correctly' do
      expect(subject.message).to eq 'Invalid email or password.'
    end

    it 'has status correctly' do
      expect(subject.status).to eq 401
    end
  end
end
