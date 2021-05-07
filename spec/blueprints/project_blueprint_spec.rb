# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectBlueprint, type: :blueprint do
  describe '#to_json' do
    subject(:json) do
      described_class.render(project)
    end

    let(:project) { create(:project) }

    it 'returns json' do
      expect(json).to be_json_eql({
        id: project.id,
        name: project.name,
        color: project.color
      }.to_json)
    end
  end
end
