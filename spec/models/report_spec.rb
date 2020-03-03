# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:end_date) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:time_zone) }

    describe 'start_date' do
      describe 'date_validator' do
        let(:start_date) { Time.now }

        subject do
          report = Report.new(
            user: create(:user),
            time_zone: 'UTC',
            start_date: start_date,
            end_date: end_date
          )
          report.valid?
          report
        end

        context 'when start_date < end_date' do
          let(:end_date) { Time.now.tomorrow }
          it { is_expected.to be_valid }
        end

        context 'when started_date = end_date' do
          let(:end_date) { start_date }
          it { expect(subject.errors).to be_include :start_date }
        end

        context 'when started_date > end_date' do
          let(:end_date) { 1.day.ago }
          it { expect(subject.errors).to be_include :start_date }
        end
      end
    end
  end

  describe '#sums' do
    let(:now) { Time.parse('2019-01-01T00:00:00') }
    let(:user) { create(:user) }

    subject do
      Report.new(
        user: user,
        time_zone: 'UTC',
        start_date: now,
        end_date: end_date
      ).sums
    end

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
        is_expected.to eq [
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
        is_expected.to eq [
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
        is_expected.to eq [
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
        is_expected.to eq [
          [projects[0].id, [0, 0, 94_608_000, 0, 0, 0, 0]],
          [projects[1].id, [0, 0, 0, 0, 94_608_000, 0, 0]]
        ].to_h
      end
    end

    context 'when user has project but activities are empty' do
      let(:end_date) { now + 6.days }

      it 'returns sums correctly' do
        project = create(:project, user: user)
        is_expected.to eq [[project.id, [0, 0, 0, 0, 0, 0, 0]]].to_h
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
          stopped_at: now - 1.days,
          user: user,
          project: project
        )
      end

      it 'returns data correctly' do
        is_expected.to eq [[project.id, [0, 0, 0, 0, 0, 0, 0]]].to_h
      end
    end

    context 'when user does not have project' do
      let(:end_date) { now + 6.days }

      it 'returns empty' do
        is_expected.to eq({})
      end
    end
  end

  describe '#totals' do
    let(:now) { Time.now }
    let(:user) { create(:user) }

    subject do
      Report.new(
        user: user,
        time_zone: 'UTC',
        start_date: now,
        end_date: now + 1.day
      ).totals
    end

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
        is_expected.to eq [
          [projects[0].id, 21_600],
          [projects[1].id, 32_400]
        ].to_h
      end
    end

    context 'when user has project but activities are empty' do
      it 'returns totals correctly' do
        project = create(:project, user: user)
        is_expected.to eq [[project.id, 0]].to_h
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
          stopped_at: now - 1.days,
          user: user,
          project: project
        )
      end

      it 'returns totals correctly' do
        is_expected.to eq [[project.id, 0]].to_h
      end
    end

    context 'when user does not have project' do
      it 'returns empty' do
        is_expected.to eq({})
      end
    end
  end

  describe '#colors' do
    let(:now) { Time.now }
    let(:user) { create(:user) }

    subject do
      Report.new(
        user: user,
        time_zone: 'UTC',
        start_date: now,
        end_date: now + 1.day
      ).colors
    end

    context 'when user has projects' do
      it 'returns colors correctly' do
        projects = create_list(:project, 2, user: user)
        is_expected.to eq [
          [projects[0].id, projects[0].color],
          [projects[1].id, projects[1].color]
        ].to_h
      end
    end

    context 'when user does not have projects' do
      it 'returns empty' do
        is_expected.to eq({})
      end
    end
  end

  describe '#projects' do
    let(:now) { Time.now }
    let(:user) { create(:user) }

    subject do
      Report.new(
        user: user,
        time_zone: 'UTC',
        start_date: now,
        end_date: now + 1.day
      ).projects
    end

    context 'when user has projects' do
      it 'returns projects correctly' do
        projects = create_list(:project, 2, user: user)
        is_expected.to eq projects
      end
    end

    context 'when user does not have projects' do
      it 'returns empty' do
        is_expected.to eq []
      end
    end
  end

  describe '#start_date' do
    let(:start_date) { Time.parse('2019-01-01T00:00:00') }

    subject do
      Report.new(
        user: create(:user),
        time_zone: time_zone,
        start_date: start_date,
        end_date: start_date + 1.day
      ).start_date
    end

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
    let(:end_date) { Time.parse('2019-01-01T00:00:00') }

    subject do
      Report.new(
        user: create(:user),
        time_zone: time_zone,
        start_date: end_date - 1.day,
        end_date: end_date
      ).end_date
    end

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
    let(:start_date) { Time.parse('2019-01-01T00:00:00') }
    let(:time_zone) { 'UTC' }

    subject do
      Report.new(
        user: create(:user),
        time_zone: time_zone,
        start_date: start_date,
        end_date: end_date
      ).labels
    end

    context 'when range is hourly' do
      let(:end_date) { start_date + 23.hours }
      it 'returns hourly labels' do
        is_expected.to eq %w[
          00 01 02 03 04 05 06 07 08 09
          10 11 12 13 14 15 16 17 18 19
          20 21 22 23
        ]
      end
    end

    context 'when range is daily' do
      let(:end_date) { start_date + 5.days }
      it 'returns daily labels' do
        is_expected.to eq %w[01 02 03 04 05 06]
      end
    end

    context 'when range is monthly' do
      let(:end_date) { start_date + 11.months }
      it 'returns monthly labels' do
        is_expected.to eq %w[
          Jan Feb Mar Apr May Jun
          Jul Aug Sep Oct Nov Dec
        ]
      end
    end

    context 'when range is yearly' do
      let(:end_date) { start_date + 2.years }
      it 'returns yearly labels' do
        is_expected.to eq %w[2019 2020 2021]
      end
    end

    context 'when range is minutely' do
      let(:end_date) { start_date + 3.minutes }
      it 'returns hours label' do
        is_expected.to eq ['00']
      end
    end

    context 'when time_zone is not UTC' do
      let(:start_date) { Time.parse('2019-01-01T15:00:00') }
      let(:end_date) { Time.parse('2019-01-02T14:59:59') }
      let(:time_zone) { 'Asia/Tokyo' }

      it 'returns labels correctly' do
        is_expected.to eq %w[
          00 01 02 03 04 05 06 07 08 09
          10 11 12 13 14 15 16 17 18 19
          20 21 22 23
        ]
      end
    end

    context 'when range has leap day' do
      let(:start_date) { Time.parse('2020-01-01T00:00:00') }
      let(:end_date) { Time.parse('2020-12-31T23:59:59') }

      it 'returns labels correctly' do
        is_expected.to eq %w[
          Jan Feb Mar Apr May Jun
          Jul Aug Sep Oct Nov Dec
        ]
      end
    end
  end

  describe '#bar_chart_data' do
    let(:now) { Time.parse('2019-01-01T00:00:00') }
    let(:user) { create(:user) }
    let(:projects) { create_list(:project, 2, user: user) }

    subject do
      Report.new(
        user: user,
        time_zone: 'UTC',
        start_date: now,
        end_date: now + 6.days
      ).bar_chart_data
    end

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
      is_expected.to eq [
        [projects[0].id, 0, 0, 259_200, 0, 0, 0, 0],
        [projects[1].id, 0, 0, 0, 0, 259_200, 0, 0]
      ]
    end
  end

  describe '#activities' do
    let(:now) { Time.now }
    let(:user) { create(:user) }

    subject do
      Report.new(
        user: user,
        time_zone: 'UTC',
        start_date: now,
        end_date: now + 1.day
      ).activities
    end

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
        is_expected.to eq user.activities
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
        is_expected.to eq []
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
        is_expected.to eq []
      end
    end

    context 'when user does not have activities' do
      it 'returns empty' do
        is_expected.to eq []
      end
    end
  end

  describe '#activity_groups' do
    let(:now) { Time.now }
    let(:user) { create(:user) }

    subject do
      Report.new(
        user: user,
        time_zone: 'UTC',
        start_date: now,
        end_date: now + 1.day
      ).activity_groups
    end

    context 'when user has activities' do
      let(:projects) { create_list(:project, 2, user: user) }

      before do
        create_list(
          :activity,
          3,
          started_at: now,
          stopped_at: now + 1.hours,
          description: 'example1',
          user: user,
          project: projects[0]
        )
        create_list(
          :activity,
          3,
          started_at: now,
          stopped_at: now + 1.hours,
          description: 'example2',
          user: user,
          project: projects[1]
        )
      end

      it 'returns grouped activities' do
        expect(subject[0].description).to eq 'example1'
        expect(subject[0].duration).to eq 10_800
        expect(subject[1].description).to eq 'example2'
        expect(subject[1].duration).to eq 10_800
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
        is_expected.to eq []
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
        is_expected.to eq []
      end
    end

    context 'when user does not have activities' do
      it 'returns empty' do
        is_expected.to eq []
      end
    end
  end
end
