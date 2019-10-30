# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportSerializer, type: :serializer do
  describe '#to_json' do
    let(:now) { Time.parse('2019-01-01T00:00:00') }
    let(:user) { create(:user) }
    let(:project) { create(:project, user: user) }

    let(:report) do
      Report.new(
        user: user,
        time_zone: 'UTC',
        start_date: now,
        end_date: now + 3.days
      )
    end

    subject do
      serializer = ReportSerializer.new(report)
      ActiveModelSerializers::Adapter.create(serializer).to_json
    end

    before do
      create(
        :activity,
        user: user,
        project: project,
        started_at: now,
        stopped_at: now + 1.day
      )
    end

    it 'returns json' do
      is_expected.to be_json_eql({
        projects: [
          {
            id: project.id,
            color: project.color,
            name: project.name,
            user_id: project.user_id
          }
        ],
        labels: %w[
          01
          02
          03
          04
        ],
        data: [
          [project.id, [86400, 0, 0, 0]]
        ].to_h,
        totals: [
          [project.id, 86_400]
        ].to_h
      }.to_json)
    end
  end
end
