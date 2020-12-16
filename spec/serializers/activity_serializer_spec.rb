# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivitySerializer, type: :serializer do
  describe '#to_json' do
    subject(:json) do
      serializer = described_class.new(activity)
      ActiveModelSerializers::Adapter.create(serializer).to_json
    end

    let(:activity) { create(:activity) }

    let(:expected_json) do
      {
        id: activity.id,
        description: activity.description,
        started_at: activity.started_at,
        stopped_at: activity.stopped_at,
        duration: activity.duration,
        project: {
          id: activity.project.id,
          name: activity.project.name,
          color: activity.project.color
        }
      }.to_json
    end

    it 'returns json' do
      expect(json).to be_json_eql(expected_json)
    end
  end
end
