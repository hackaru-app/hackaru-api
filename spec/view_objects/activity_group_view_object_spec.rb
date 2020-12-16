# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityGroupViewObject, type: :view_object do
  describe '#description' do
    subject { described_class.new(activity_group).description }

    context 'when activity has description' do
      let(:activity_group) do
        ActivityGroup.new(
          project: create(:project, name: 'Review'),
          description: 'Review code',
          duration: 0
        )
      end

      it { is_expected.to eq('Review code') }
    end

    context 'when activity does not have description' do
      let(:activity_group) do
        ActivityGroup.new(
          project: create(:project, name: 'Review'),
          description: '',
          duration: 0
        )
      end

      it { is_expected.to eq('Review') }
    end
  end

  describe '#color' do
    subject { described_class.new(activity_group).color }

    let(:activity_group) do
      ActivityGroup.new(
        project: create(:project, color: '#ff0'),
        description: '',
        duration: 0
      )
    end

    it { is_expected.to eq('#ff0') }
  end

  describe '#duration' do
    subject { described_class.new(activity_group).duration }

    let(:activity_group) do
      ActivityGroup.new(
        project: create(:project),
        description: '',
        duration: 1000
      )
    end

    it { is_expected.to eq(1000) }
  end
end
