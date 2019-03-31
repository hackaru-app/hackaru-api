# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportSerializer, type: :serializer do
  describe '#to_json' do
    let(:now) { Time.parse('2019-01-01T01:23:45') }
    let(:project) { create(:project) }
    let(:report) { Report.new(project.user, range, period) }

    subject do
      serializer = ReportSerializer.new(report)
      ActiveModelSerializers::Adapter.create(serializer).to_json
    end

    context 'when period is hour' do
      let(:period) { 'hour' }
      let(:range) { (now - 2.hours)..now }

      before do
        create(
          :activity,
          user: project.user,
          project: project,
          started_at: now - 1.hour,
          stopped_at: now
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
          summary: [
            {
              date: '2018-12-31T23:00:00.000Z',
              project_id: project.id,
              duration: 0
            },
            {
              date: '2019-01-01T00:00:00.000Z',
              project_id: project.id,
              duration: 3600
            },
            {
              date: '2019-01-01T01:00:00.000Z',
              project_id: project.id,
              duration: 0
            }
          ]
        }.to_json)
      end
    end

    context 'when period is day' do
      let(:period) { 'day' }
      let(:range) { (now - 2.days)..now }

      before do
        create(
          :activity,
          user: project.user,
          project: project,
          started_at: now - 1.day,
          stopped_at: now
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
          summary: [
            { date: '2018-12-30', project_id: project.id, duration: 0 },
            { date: '2018-12-31', project_id: project.id, duration: 86_400 },
            { date: '2019-01-01', project_id: project.id, duration: 0 }
          ]
        }.to_json)
      end
    end

    context 'when period is month' do
      let(:period) { 'month' }
      let(:range) { (now - 2.months)..now }

      before do
        create(
          :activity,
          user: project.user,
          project: project,
          started_at: now - 1.month,
          stopped_at: now
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
          summary: [
            { date: '2018-11-01', project_id: project.id, duration: 0 },
            { date: '2018-12-01', project_id: project.id, duration: 2_678_400 },
            { date: '2019-01-01', project_id: project.id, duration: 0 }
          ]
        }.to_json)
      end
    end
  end
end
