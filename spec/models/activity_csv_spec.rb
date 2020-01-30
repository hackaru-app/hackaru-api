# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityCsv, type: :model do
  describe '#generate' do
    subject { described_class.new(activities).generate }

    context 'when activities is not empty' do
      let(:project) do
        create(:project, name: 'ProjectName')
      end

      let(:activities) do
        create_list(
          :activity,
          1,
          user: project.user,
          project: project,
          started_at: Time.new(2020, 1, 1),
          stopped_at: Time.new(2020, 1, 2),
          description: 'Description'
        )
      end

      it 'generates headers' do
        expect(subject.split("\n")[0]).to eq [
          '"Id"',
          '"ProjectId"',
          '"ProjectName"',
          '"Description"',
          '"StartedAt"',
          '"StoppedAt"',
          '"Duration"'
        ].join(',')
      end

      it 'generates value' do
        expect(subject.split("\n")[1]).to eq [
          "\"#{activities[0].id}\"",
          "\"#{project.id}\"",
          '"ProjectName"',
          '"Description"',
          '"2020-01-01 00:00:00 UTC"',
          '"2020-01-02 00:00:00 UTC"',
          '"86400"'
        ].join(',')
      end
    end

    context 'when activity does not have project' do
      let(:activities) do
        create_list(
          :activity,
          1,
          project: nil,
          started_at: Time.new(2020, 1, 1),
          stopped_at: Time.new(2020, 1, 2),
          description: 'Description'
        )
      end

      it 'generates value' do
        expect(subject.split("\n")[1]).to eq [
          "\"#{activities[0].id}\"",
          '""',
          '""',
          '"Description"',
          '"2020-01-01 00:00:00 UTC"',
          '"2020-01-02 00:00:00 UTC"',
          '"86400"'
        ].join(',')
      end
    end

    context 'when activity does not have description' do
      let(:activities) do
        create_list(
          :activity,
          1,
          project: nil,
          started_at: Time.new(2020, 1, 1),
          stopped_at: Time.new(2020, 1, 2),
          description: ''
        )
      end

      it 'generates value' do
        expect(subject.split("\n")[1]).to eq [
          "\"#{activities[0].id}\"",
          '""',
          '""',
          '""',
          '"2020-01-01 00:00:00 UTC"',
          '"2020-01-02 00:00:00 UTC"',
          '"86400"'
        ].join(',')
      end
    end

    context 'when activity is not stopped' do
      let(:activities) do
        create_list(
          :activity,
          1,
          project: nil,
          description: '',
          started_at: Time.new(2020, 1, 1),
          stopped_at: nil
        )
      end

      it 'generates value' do
        expect(subject.split("\n")[1]).to eq [
          "\"#{activities[0].id}\"",
          '""',
          '""',
          '""',
          '"2020-01-01 00:00:00 UTC"',
          '""',
          '""'
        ].join(',')
      end
    end

    context 'when activities is empty' do
      let(:activities) { [] }

      it 'generates headers' do
        expect(subject.split("\n")[0]).to eq [
          '"Id"',
          '"ProjectId"',
          '"ProjectName"',
          '"Description"',
          '"StartedAt"',
          '"StoppedAt"',
          '"Duration"'
        ].join(',')
      end

      it 'generates header only' do
        expect(subject.split("\n").size).to eq(1)
      end
    end
  end
end
