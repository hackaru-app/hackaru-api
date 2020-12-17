# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityCsv, type: :model do
  describe '#generate_bom' do
    subject(:csv) do
      described_class.new(activities, time_zone).generate_bom
    end

    let(:time_zone) { 'UTC' }

    context 'when activities is present' do
      let(:project) do
        create(:project, name: 'Project')
      end

      let(:activities) do
        create_list(
          :activity,
          1,
          user: project.user,
          project: project,
          started_at: Time.zone.local(2020, 1, 1),
          stopped_at: Time.zone.local(2020, 1, 2),
          description: 'Description'
        )
      end

      let(:expected_headers) do
        [
          "\uFEFF\"Id\"",
          '"ProjectId"',
          '"ProjectName"',
          '"Description"',
          '"StartedAt"',
          '"StoppedAt"',
          '"Duration"'
        ].join(',')
      end

      let(:expected_values) do
        [
          "\"#{activities[0].id}\"",
          "\"#{project.id}\"",
          '"Project"',
          '"Description"',
          '"2020-01-01 00:00:00"',
          '"2020-01-02 00:00:00"',
          '"86400"'
        ].join(',')
      end

      it 'generates headers' do
        expect(csv.split("\n")[0]).to eq(expected_headers)
      end

      it 'generates values' do
        expect(csv.split("\n")[1]).to eq(expected_values)
      end
    end

    context 'when time zone is not UTC' do
      let(:time_zone) { 'Asia/Tokyo' }

      let(:activities) do
        create_list(
          :activity,
          1,
          project: nil,
          started_at: Time.zone.local(2020, 1, 1),
          stopped_at: Time.zone.local(2020, 1, 2),
          description: 'Description'
        )
      end

      let(:expected_values) do
        [
          "\"#{activities[0].id}\"",
          '""',
          '""',
          '"Description"',
          '"2020-01-01 09:00:00"',
          '"2020-01-02 09:00:00"',
          '"86400"'
        ].join(',')
      end

      it 'generates values' do
        expect(csv.split("\n")[1]).to eq(expected_values)
      end
    end

    context 'when activity does not have project' do
      let(:activities) do
        create_list(
          :activity,
          1,
          project: nil,
          started_at: Time.zone.local(2020, 1, 1),
          stopped_at: Time.zone.local(2020, 1, 2),
          description: 'Description'
        )
      end

      let(:expected_values) do
        [
          "\"#{activities[0].id}\"",
          '""',
          '""',
          '"Description"',
          '"2020-01-01 00:00:00"',
          '"2020-01-02 00:00:00"',
          '"86400"'
        ].join(',')
      end

      it 'generates values' do
        expect(csv.split("\n")[1]).to eq(expected_values)
      end
    end

    context 'when activity does not have description' do
      let(:activities) do
        create_list(
          :activity,
          1,
          project: nil,
          started_at: Time.zone.local(2020, 1, 1),
          stopped_at: Time.zone.local(2020, 1, 2),
          description: ''
        )
      end

      let(:expected_values) do
        [
          "\"#{activities[0].id}\"",
          '""',
          '""',
          '""',
          '"2020-01-01 00:00:00"',
          '"2020-01-02 00:00:00"',
          '"86400"'
        ].join(',')
      end

      it 'generates values' do
        expect(csv.split("\n")[1]).to eq(expected_values)
      end
    end

    context 'when activity is not stopped' do
      let(:activities) do
        create_list(
          :activity,
          1,
          project: nil,
          description: '',
          started_at: Time.zone.local(2020, 1, 1),
          stopped_at: nil
        )
      end

      let(:expected_values) do
        [
          "\"#{activities[0].id}\"",
          '""',
          '""',
          '""',
          '"2020-01-01 00:00:00"',
          '""',
          '""'
        ].join(',')
      end

      it 'generates values' do
        expect(csv.split("\n")[1]).to eq(expected_values)
      end
    end

    context 'when activities is empty' do
      let(:activities) { [] }

      let(:expected_headers) do
        [
          "\uFEFF\"Id\"",
          '"ProjectId"',
          '"ProjectName"',
          '"Description"',
          '"StartedAt"',
          '"StoppedAt"',
          '"Duration"'
        ].join(',')
      end

      it 'generates headers' do
        expect(csv.split("\n")[0]).to eq(expected_headers)
      end

      it 'does not generates values' do
        expect(csv.split("\n").size).to eq(1)
      end
    end
  end
end
