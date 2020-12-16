# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserInitializer, type: :model do
  describe '#create!' do
    subject(:instance) do
      described_class.new(
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password',
        time_zone: 'UTC',
        locale: 'en'
      ).create!
    end

    it { expect(instance.email).to eq('test@example.com') }
    it { expect(instance.password).to eq('password') }
    it { expect(instance.projects.size).to eq(3) }
    it { expect(instance.time_zone).to eq('UTC') }
  end
end
