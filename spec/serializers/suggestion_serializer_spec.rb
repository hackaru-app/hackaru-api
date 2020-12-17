# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SuggestionSerializer, type: :serializer do
  describe '#to_json' do
    subject(:json) do
      serializer = described_class.new(suggestion)
      ActiveModelSerializers::Adapter.create(serializer).to_json
    end

    let(:suggestion) { create(:suggestion) }

    let(:expected_json) do
      {
        description: suggestion.description,
        project: {
          id: suggestion.project.id,
          name: suggestion.project.name,
          color: suggestion.project.color
        }
      }.to_json
    end

    it 'returns json' do
      expect(json).to be_json_eql(expected_json)
    end
  end
end
