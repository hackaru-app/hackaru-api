# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserInitializer, type: :model do
  describe '#create!' do
    subject do
      described_class.new(
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password',
        time_zone: 'UTC',
        locale: 'en'
      ).create!
    end

    it { expect(subject.email).to eq('test@example.com') }
    it { expect(subject.password).to eq('password') }
    it { expect(subject.projects.size).to eq(3) }
    it { expect(subject.time_zone).to eq('UTC') }
  end
end
