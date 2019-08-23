# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SuggestionSerializer, type: :serializer do
  describe '#to_json' do
    let(:suggestion) { create(:suggestion) }

    subject do
      serializer = SuggestionSerializer.new(suggestion)
      ActiveModelSerializers::Adapter.create(serializer).to_json
    end

    it 'returns json' do
      is_expected.to be_json_eql({
        description: suggestion.description,
        project: {
          id: suggestion.project.id,
          name: suggestion.project.name,
          color: suggestion.project.color
        }
      }.to_json)
    end
  end
end
