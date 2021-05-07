# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityGroupBlueprint, type: :blueprint do
  describe '#to_json' do
    subject(:json) do
      described_class.render(activity_group)
    end

    let(:project) { create(:project) }
    let(:activity_group) do
      ActivityGroup.new(
        description: 'Review',
        duration: 1000,
        project: project
      )
    end

    let(:expected_json) do
      {
        description: 'Review',
        duration: 1000,
        project: {
          id: project.id,
          name: project.name,
          color: project.color
        }
      }.to_json
    end

    it 'returns json' do
      expect(json).to be_json_eql(expected_json)
    end
  end
end
