# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectSerializer, type: :serializer do
  describe '#to_json' do
    subject(:json) do
      serializer = described_class.new(project)
      ActiveModelSerializers::Adapter.create(serializer).to_json
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
