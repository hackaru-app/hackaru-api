# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectSerializer, type: :serializer do
  describe '#to_json' do
    let(:project) { create(:project) }

    subject do
      serializer = ProjectSerializer.new(project)
      ActiveModelSerializers::Adapter.create(serializer).to_json
    end

    it 'returns json' do
      is_expected.to be_json_eql({
        id: project.id,
        name: project.name,
        color: project.color
      }.to_json)
    end
  end
end
