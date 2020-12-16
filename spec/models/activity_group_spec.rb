# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityGroup, type: :model do
  describe 'validations' do
    subject { described_class.new }

    it { is_expected.to validate_presence_of(:project) }
    it { is_expected.to validate_presence_of(:duration) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe '.generate' do
    subject(:instance) { described_class.generate(Activity.all) }

    context 'when activity is not empty' do
      let(:project) { create(:project) }

      before do
        create_list(
          :activity, 2,
          user: project.user,
          project: project,
          description: 'Review code',
          started_at: Date.new(2019, 1, 1),
          stopped_at: Date.new(2019, 1, 2)
        )
      end

      it { expect(instance.size).to eq(1) }
      it { expect(instance.first.project).to eq(project) }
      it { expect(instance.first.description).to eq('Review code') }
      it { expect(instance.first.duration).to eq(172_800) }
    end

    context 'when activity is empty' do
      let(:activities) { [] }

      it { expect(instance).to be_empty }
    end
  end
end
