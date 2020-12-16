# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityCalendarSerializer, type: :serializer do
  describe '#to_json' do
    subject(:json) do
      serializer = described_class.new(activity_calendar)
      ActiveModelSerializers::Adapter.create(serializer).to_json
    end

    let(:activity_calendar) { create(:activity_calendar) }

    it 'returns json' do
      expect(json).to be_json_eql({
        user_id: activity_calendar.user_id,
        token: activity_calendar.token
      }.to_json)
    end
  end
end
