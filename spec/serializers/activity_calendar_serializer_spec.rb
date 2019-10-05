# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityCalendarSerializer, type: :serializer do
  describe '#to_json' do
    let(:activity_calendar) { create(:activity_calendar) }

    subject do
      serializer = ActivityCalendarSerializer.new(activity_calendar)
      ActiveModelSerializers::Adapter.create(serializer).to_json
    end

    it 'returns json' do
      is_expected.to be_json_eql({
        user_id: activity_calendar.user_id,
        token: activity_calendar.token
      }.to_json)
    end
  end
end
