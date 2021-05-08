# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityCalendarBlueprint, type: :blueprint do
  describe '#to_json' do
    subject(:json) do
      described_class.render(activity_calendar)
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
