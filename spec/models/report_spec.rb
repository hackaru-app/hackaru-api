# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  describe 'validations' do
    subject(:instance) do
      report = described_class.new(
        projects: [],
        time_zone: 'Etc/UTC',
        start_date: start_date,
        end_date: end_date
      )
      report.valid?
      report
    end

    let(:start_date) { Time.zone.now }
    let(:end_date) { Time.zone.now }

    it { is_expected.to validate_presence_of(:end_date) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:time_zone) }

    context 'when start_date < end_date' do
      let(:end_date) { Time.zone.now.tomorrow }

      it { is_expected.to be_valid }
    end

    context 'when start_date = end_date' do
      let(:end_date) { start_date }

      it { expect(instance.errors).to be_include :start_date }
    end

    context 'when start_date > end_date' do
      let(:end_date) { 1.day.ago }

      it { expect(instance.errors).to be_include :start_date }
    end
  end

  describe '#sums' do
    subject(:sums) do
      described_class.new(
        projects: user.projects,
        time_zone: 'Etc/UTC',
        start_date: now,
        end_date: end_date
      ).sums
    end

    let(:now) { Time.zone.parse('2019-01-01T00:00:00') }
    let(:user) { create(:user) }

    context 'when range is hourly' do
      let(:end_date) { now + 6.hours }
      let(:projects) { create_list(:project, 2, user: user) }

      before do
        create_list(
          :activity,
          3,
          started_at: now + 2.hours,
          stopped_at: now + 3.hours,
          user: user,
          project: projects[0]
        )
        create_list(
          :activity,
          3,
          started_at: now + 4.hours,
          stopped_at: now + 5.hours,
          user: user,
          project: projects[1]
        )
      end

      it 'returns sums correctly' do
        expect(sums).to eq [
          [projects[0].id, [0, 0, 10_800, 0, 0, 0, 0]],
          [projects[1].id, [0, 0, 0, 0, 10_800, 0, 0]]
        ].to_h
      end
    end

    context 'when range is daily' do
      let(:end_date) { now + 6.days }
      let(:projects) { create_list(:project, 2, user: user) }

      before do
        create_list(
          :activity,
          3,
          started_at: now + 2.days,
          stopped_at: now + 3.days,
          user: user,
          project: projects[0]
        )
        create_list(
          :activity,
          3,
          started_at: now + 4.days,
          stopped_at: now + 5.days,
          user: user,
          project: projects[1]
        )
      end

      it 'returns sums correctly' do
        expect(sums).to eq [
          [projects[0].id, [0, 0, 259_200, 0, 0, 0, 0]],
          [projects[1].id, [0, 0, 0, 0, 259_200, 0, 0]]
        ].to_h
      end
    end

    context 'when range is monthly' do
      let(:end_date) { now + 6.months }
      let(:projects) { create_list(:project, 2, user: user) }

      before do
        create_list(
          :activity,
          3,
          started_at: now + 2.months,
          stopped_at: now + 3.months,
          user: user,
          project: projects[0]
        )
        create_list(
          :activity,
          3,
          started_at: now + 4.months,
          stopped_at: now + 5.months,
          user: user,
          project: projects[1]
        )
      end

      it 'returns sums correctly' do
        expect(sums).to eq [
          [projects[0].id, [0, 0, 8_035_200, 0, 0, 0, 0]],
          [projects[1].id, [0, 0, 0, 0, 8_035_200, 0, 0]]
        ].to_h
      end
    end

    context 'when range is yearly' do
      let(:end_date) { now + 6.years }
      let(:projects) { create_list(:project, 2, user: user) }

      before do
        create_list(
          :activity,
          3,
          started_at: now + 2.years,
          stopped_at: now + 3.years,
          user: user,
          project: projects[0]
        )
        create_list(
          :activity,
          3,
          started_at: now + 4.years,
          stopped_at: now + 5.years,
          user: user,
          project: projects[1]
        )
      end

      it 'returns sums correctly' do
        expect(sums).to eq [
          [projects[0].id, [0, 0, 94_608_000, 0, 0, 0, 0]],
          [projects[1].id, [0, 0, 0, 0, 94_608_000, 0, 0]]
        ].to_h
      end
    end

    context 'when user has project but activities are empty' do
      let(:end_date) { now + 6.days }

      it 'returns sums correctly' do
        project = create(:project, user: user)
        expect(sums).to eq [[project.id, [0, 0, 0, 0, 0, 0, 0]]].to_h
      end
    end

    context 'when user has project but date is out of range' do
      let(:end_date) { now + 6.days }
      let(:project) { create(:project, user: user) }

      before do
        create(
          :activity,
          started_at: now + 7.days,
          stopped_at: now + 8.days,
          user: user,
          project: project
        )
        create(
          :activity,
          started_at: now - 2.days,
          stopped_at: now - 1.day,
          user: user,
          project: project
        )
      end

      it 'returns data correctly' do
        expect(sums).to eq [[project.id, [0, 0, 0, 0, 0, 0, 0]]].to_h
      end
    end

    context 'when user does not have project' do
      let(:end_date) { now + 6.days }

      it 'returns empty' do
        expect(sums).to eq({})
      end
    end
  end

  describe '#totals' do
    subject(:totals) do
      described_class.new(
        projects: user.projects,
        time_zone: 'Etc/UTC',
        start_date: now,
        end_date: now + 1.day
      ).totals
    end

    let(:now) { Time.zone.now }
    let(:user) { create(:user) }

    context 'when user has projects and activities' do
      let(:projects) { create_list(:project, 2, user: user) }

      before do
        create_list(
          :activity,
          3,
          started_at: now,
          stopped_at: now + 2.hours,
          user: user,
          project: projects[0]
        )
        create_list(
          :activity,
          3,
          started_at: now,
          stopped_at: now + 3.hours,
          user: user,
          project: projects[1]
        )
      end

      it 'returns totals correctly' do
        expect(totals).to eq [
          [projects[0].id, 21_600],
          [projects[1].id, 32_400]
        ].to_h
      end
    end

    context 'when user has project but activities are empty' do
      it 'returns totals correctly' do
        project = create(:project, user: user)
        expect(totals).to eq [[project.id, 0]].to_h
      end
    end

    context 'when user has project but date is out of range' do
      let(:project) { create(:project, user: user) }

      before do
        create(
          :activity,
          started_at: now + 2.days,
          stopped_at: now + 3.days,
          user: user,
          project: project
        )
        create(
          :activity,
          started_at: now - 2.days,
          stopped_at: now - 1.day,
          user: user,
          project: project
        )
      end

      it 'returns totals correctly' do
        expect(totals).to eq [[project.id, 0]].to_h
      end
    end

    context 'when user does not have project' do
      it 'returns empty' do
        expect(totals).to eq({})
      end
    end
  end

  describe '#colors' do
    subject(:colors) do
      described_class.new(
        projects: user.projects,
        time_zone: 'Etc/UTC',
        start_date: now,
        end_date: now + 1.day
      ).colors
    end

    let(:now) { Time.zone.now }
    let(:user) { create(:user) }

    context 'when user has projects' do
      it 'returns colors correctly' do
        projects = create_list(:project, 2, user: user)
        expect(colors).to eq [
          [projects[0].id, projects[0].color],
          [projects[1].id, projects[1].color]
        ].to_h
      end
    end

    context 'when user does not have projects' do
      it 'returns empty' do
        expect(colors).to eq({})
      end
    end
  end

  describe '#projects' do
    subject(:projects) do
      described_class.new(
        projects: user.projects,
        time_zone: 'Etc/UTC',
        start_date: now,
        end_date: now + 1.day
      ).projects
    end

    let(:now) { Time.zone.now }
    let(:user) { create(:user) }

    context 'when user has projects' do
      it 'returns projects correctly' do
        projects = create_list(:project, 2, user: user)
        expect(projects).to eq projects
      end
    end

    context 'when user does not have projects' do
      it 'returns empty' do
        expect(projects).to eq []
      end
    end
  end

  describe '#start_date' do
    subject do
      described_class.new(
        projects: [],
        time_zone: time_zone,
        start_date: start_date,
        end_date: start_date + 1.day
      ).start_date
    end

    let(:start_date) { Time.zone.parse('2019-01-01T00:00:00') }

    context 'when time_zone is UTC' do
      let(:time_zone) { 'UTC' }

      it { is_expected.to eq start_date.in_time_zone('UTC') }
    end

    context 'when time_zone is Asia/Tokyo' do
      let(:time_zone) { 'Asia/Tokyo' }

      it { is_expected.to eq start_date.in_time_zone('Asia/Tokyo') }
    end
  end

  describe '#end_date' do
    subject do
      described_class.new(
        projects: [],
        time_zone: time_zone,
        start_date: end_date - 1.day,
        end_date: end_date
      ).end_date
    end

    let(:end_date) { Time.zone.parse('2019-01-01T00:00:00') }

    context 'when time_zone is UTC' do
      let(:time_zone) { 'UTC' }

      it { is_expected.to eq end_date.in_time_zone('UTC') }
    end

    context 'when time_zone is Asia/Tokyo' do
      let(:time_zone) { 'Asia/Tokyo' }

      it { is_expected.to eq end_date.in_time_zone('Asia/Tokyo') }
    end
  end

  describe '#labels' do
    subject(:labels) do
      described_class.new(
        projects: [],
        time_zone: time_zone,
        start_date: start_date,
        end_date: end_date
      ).labels
    end

    let(:start_date) { Time.zone.parse('2019-01-01T00:00:00') }
    let(:time_zone) { 'UTC' }

    context 'when range is hourly' do
      let(:end_date) { start_date + 23.hours }

      it 'returns hourly labels' do
        expect(labels).to eq %w[
          00 01 02 03 04 05 06 07 08 09
          10 11 12 13 14 15 16 17 18 19
          20 21 22 23
        ]
      end
    end

    context 'when range is daily' do
      let(:end_date) { start_date + 5.days }

      it 'returns daily labels' do
        expect(labels).to eq %w[01 02 03 04 05 06]
      end
    end

    context 'when range is monthly' do
      let(:end_date) { start_date + 11.months }

      it 'returns monthly labels' do
        expect(labels).to eq %w[
          Jan Feb Mar Apr May Jun
          Jul Aug Sep Oct Nov Dec
        ]
      end
    end

    context 'when range is yearly' do
      let(:end_date) { start_date + 2.years }

      it 'returns yearly labels' do
        expect(labels).to eq %w[2019 2020 2021]
      end
    end

    context 'when range is minutely' do
      let(:end_date) { start_date + 3.minutes }

      it 'returns hours label' do
        expect(labels).to eq ['00']
      end
    end

    context 'when time_zone is not UTC' do
      let(:start_date) { Time.zone.parse('2019-01-01T15:00:00') }
      let(:end_date) { Time.zone.parse('2019-01-02T14:59:59') }
      let(:time_zone) { 'Asia/Tokyo' }

      it 'returns labels correctly' do
        expect(labels).to eq %w[
          00 01 02 03 04 05 06 07 08 09
          10 11 12 13 14 15 16 17 18 19
          20 21 22 23
        ]
      end
    end

    context 'when range has leap day' do
      let(:start_date) { Time.zone.parse('2020-01-01T00:00:00') }
      let(:end_date) { Time.zone.parse('2020-12-31T23:59:59') }

      it 'returns labels correctly' do
        expect(labels).to eq %w[
          Jan Feb Mar Apr May Jun
          Jul Aug Sep Oct Nov Dec
        ]
      end
    end
  end

  describe '#bar_chart_data' do
    subject(:bar_chart_data) do
      described_class.new(
        projects: user.projects,
        time_zone: 'Etc/UTC',
        start_date: now,
        end_date: now + 6.days
      ).bar_chart_data
    end

    let(:now) { Time.zone.parse('2019-01-01T00:00:00') }
    let(:user) { create(:user) }
    let(:projects) { create_list(:project, 2, user: user) }

    before do
      create_list(
        :activity,
        3,
        started_at: now + 2.days,
        stopped_at: now + 3.days,
        user: user,
        project: projects[0]
      )
      create_list(
        :activity,
        3,
        started_at: now + 4.days,
        stopped_at: now + 5.days,
        user: user,
        project: projects[1]
      )
    end

    it 'returns data correctly' do
      expect(bar_chart_data).to eq [
        [projects[0].id, 0, 0, 259_200, 0, 0, 0, 0],
        [projects[1].id, 0, 0, 0, 0, 259_200, 0, 0]
      ]
    end
  end

  describe '#activities' do
    subject(:activities) do
      described_class.new(
        projects: user.projects,
        time_zone: 'Etc/UTC',
        start_date: now,
        end_date: now + 1.day
      ).activities
    end

    let(:now) { Time.zone.now }
    let(:user) { create(:user) }

    context 'when user has activities' do
      before do
        create(
          :activity,
          started_at: now,
          stopped_at: now,
          description: 'example1',
          user: user
        )
        create(
          :activity,
          started_at: now + 1.day,
          stopped_at: now + 1.day,
          description: 'example1',
          user: user
        )
      end

      it 'returns activities' do
        expect(activities).to eq user.activities
      end
    end

    context 'when user has activities but out of range' do
      before do
        create(
          :activity,
          started_at: now - 1.day,
          stopped_at: now - 1.day,
          description: 'example1',
          user: user
        )
        create(
          :activity,
          started_at: now + 2.days,
          stopped_at: now + 2.days,
          description: 'example1',
          user: user
        )
      end

      it 'returns empty' do
        expect(activities).to eq []
      end
    end

    context 'when user has working activities' do
      before do
        create(
          :activity,
          started_at: now,
          stopped_at: nil,
          duration: nil,
          description: 'example1',
          user: user
        )
      end

      it 'returns empty' do
        expect(activities).to eq []
      end
    end

    context 'when user does not have activities' do
      it 'returns empty' do
        expect(activities).to eq []
      end
    end
  end

  describe '#activity_groups' do
    subject(:activity_groups) do
      described_class.new(
        projects: user.projects,
        time_zone: 'Etc/UTC',
        start_date: now,
        end_date: now + 1.day
      ).activity_groups
    end

    let(:now) { Time.zone.now }
    let(:user) { create(:user) }

    context 'when user has activities' do
      let(:projects) { create_list(:project, 2, user: user) }

      before do
        create_list(
          :activity,
          3,
          started_at: now,
          stopped_at: now + 1.hour,
          description: 'example1',
          user: user,
          project: projects[0]
        )
        create_list(
          :activity,
          3,
          started_at: now,
          stopped_at: now + 1.hour,
          description: 'example2',
          user: user,
          project: projects[1]
        )
      end

      it 'returns grouped activities with description' do
        expect(activity_groups.map(&:description)).to eq(%w[example1 example2])
      end

      it 'returns grouped activities with duration' do
        expect(activity_groups.map(&:duration)).to eq([10_800, 10_800])
      end
    end

    context 'when user has activities but out of range' do
      before do
        create(
          :activity,
          started_at: now - 1.day,
          stopped_at: now,
          description: 'example1',
          user: user
        )
        create(
          :activity,
          started_at: now + 2.days,
          stopped_at: now + 3.days,
          description: 'example1',
          user: user
        )
      end

      it 'returns empty' do
        expect(activity_groups).to eq []
      end
    end

    context 'when user has working activities' do
      before do
        create(
          :activity,
          started_at: now,
          stopped_at: nil,
          duration: nil,
          description: 'example1',
          user: user
        )
      end

      it 'returns empty' do
        expect(activity_groups).to eq []
      end
    end

    context 'when user does not have activities' do
      it 'returns empty' do
        expect(activity_groups).to eq []
      end
    end
  end
end
