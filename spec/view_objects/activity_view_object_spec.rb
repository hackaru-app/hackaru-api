# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityViewObject, type: :view_object do
  describe '#description' do
    subject { described_class.new(activity).description }

    context 'when activity has description' do
      let(:activity) { create(:activity, description: 'Review') }

      it { is_expected.to eq('Review') }
    end

    context 'when activity does not have description' do
      let(:project) { create(:project, name: 'Development') }
      let(:activity) do
        create(
          :activity,
          user: project.user,
          project: project,
          description: ''
        )
      end

      it { is_expected.to eq('Development') }
    end

    context 'when activity does not have description and project' do
      let(:activity) { create(:activity, description: '', project: nil) }

      it { is_expected.to eq('No Project') }
    end
  end

  describe '#color' do
    subject { described_class.new(activity).color }

    context 'when activity has project' do
      let(:project) { create(:project, color: '#ff0') }
      let(:activity) do
        create(
          :activity,
          user: project.user,
          project: project
        )
      end

      it { is_expected.to eq('#ff0') }
    end

    context 'when activity does not have project' do
      let(:activity) { create(:activity, project: nil) }

      it { is_expected.to eq('#cccfd9') }
    end
  end

  describe '#duration' do
    subject { described_class.new(activity).duration }

    context 'when activity is stopped' do
      let(:activity) do
        create(
          :activity,
          started_at: Date.new(2019, 1, 1),
          stopped_at: Date.new(2019, 1, 2)
        )
      end

      it { is_expected.to eq(86_400) }
    end

    context 'when activity is working' do
      let(:activity) { create(:activity, stopped_at: nil) }

      it { is_expected.to be_nil }
    end
  end
end
