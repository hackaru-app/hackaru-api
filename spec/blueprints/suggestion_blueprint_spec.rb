# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SuggestionBlueprint, type: :blueprint do
  describe '#to_json' do
    subject(:json) do
      described_class.render(suggestion)
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
