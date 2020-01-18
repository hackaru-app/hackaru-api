# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserInitializer, type: :model do
  describe '#create!' do
    subject do
      described_class.new(
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      ).create!
    end

    it 'has email' do
      expect(subject.email).to eq('test@example.com')
    end

    it 'has password' do
      expect(subject.password).to eq('password')
    end

    it 'has projects' do
      expect(subject.projects.size).to eq(3)
    end
  end
end
