# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  describe '#to_json' do
    let(:user) { create(:user) }

    subject do
      serializer = UserSerializer.new(user)
      ActiveModelSerializers::Adapter.create(serializer).to_json
    end

    it 'returns json' do
      is_expected.to be_json_eql({
        id: user.id,
        email: user.email
      }.to_json)
    end
  end
end
