# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportBlueprint, type: :blueprint do
  describe '#to_json' do
    subject(:json) do
      described_class.render(report)
    end

    let(:user) { create(:user) }
    let(:project) { create(:project, user: user) }
    let(:now) { Time.zone.parse('2019-01-01T00:00:00') }
    let(:expected_json) do
      {
        projects: [
          {
            id: project.id,
            color: project.color,
            name: project.name
          }
        ],
        labels: %w[
          01
          02
          03
          04
        ],
        sums: [
          [project.id, [86_400, 0, 0, 0]]
        ].to_h,
        totals: [
          [project.id, 86_400]
        ].to_h,
        activity_groups: [
          {
            description: 'Review',
            duration: 86_400,
            project: {
              color: project.color,
              name: project.name
            }
          }
        ]
      }.to_json
    end

    let(:report) do
      Report.new(
        projects: user.projects,
        time_zone: 'Etc/UTC',
        start_date: now,
        end_date: now + 3.days
      )
    end

    before do
      create(
        :activity,
        user: user,
        project: project,
        description: 'Review',
        started_at: now,
        stopped_at: now + 1.day
      )
    end

    it 'returns json' do
      expect(json).to be_json_eql(expected_json)
    end
  end
end
