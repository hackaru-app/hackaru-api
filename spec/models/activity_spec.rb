# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:project).optional }
  end

  describe 'validations' do
    subject(:instance) do
      activity = build(
        :activity,
        started_at: started_at,
        stopped_at: stopped_at
      )
      activity.valid?
      activity
    end

    let(:started_at) { Time.zone.now }
    let(:stopped_at) { Time.zone.now }

    it { is_expected.to validate_presence_of(:started_at) }
    it { is_expected.to validate_length_of(:description).is_at_most(191) }

    context 'when started_at < stopped_at' do
      let(:stopped_at) { Time.zone.now.tomorrow }

      it { is_expected.to be_valid }
    end

    context 'when started_at = stopped_at' do
      let(:stopped_at) { started_at }

      it { is_expected.to be_valid }
    end

    context 'when started_at > stopped_at' do
      let(:stopped_at) { 1.day.ago }

      it { expect(instance.errors).to be_include :started_at }
    end

    context 'when stopped_at is nil' do
      let(:stopped_at) { nil }

      it { is_expected.to be_valid }
    end

    context 'when started_at + 1.year < stopped_at' do
      let(:stopped_at) { started_at.next_year.tomorrow }

      it { expect(instance.errors).to be_include :stopped_at }
    end

    context 'when started_at + 1.year = stopped_at' do
      let(:stopped_at) { started_at.next_year }

      it { is_expected.to be_valid }
    end

    context 'when started_at + 1.year > stopped_at' do
      let(:stopped_at) { started_at.next_year.yesterday }

      it { is_expected.to be_valid }
    end
  end

  describe '.between' do
    subject { described_class.between(now - 3.days, now - 1.day).size }

    let(:now) { Time.zone.now }

    context 'when activities are contained' do
      before do
        create(:activity, started_at: now - 3.days, stopped_at: now)
        create(:activity, started_at: now - 3.days, stopped_at: now - 2.days)
        create(:activity, started_at: now - 6.days, stopped_at: now - 2.days)
        create(:activity, started_at: now - 3.days, stopped_at: now - 1.day)
      end

      it { is_expected.to eq 4 }
    end

    context 'when activities are not contained' do
      before do
        create(:activity, started_at: now - 6.days, stopped_at: now - 5.days)
        create(:activity, started_at: now + 1.day, stopped_at: now + 2.days)
      end

      it { is_expected.to be_zero }
    end

    context 'when \'from\' parameter is nil' do
      subject { described_class.between(nil, now) }

      before { create_list(:activity, 3) }

      it { is_expected.to be_empty }
    end

    context 'when \'to\' parameter is nil' do
      subject { described_class.between(now, nil) }

      before { create_list(:activity, 3) }

      it { is_expected.to be_empty }
    end
  end

  describe '.stopped' do
    subject { described_class.stopped.size }

    let(:now) { Time.zone.now }

    context 'when activities are stopped' do
      before do
        create_list(
          :activity,
          3,
          started_at: now,
          stopped_at: now.tomorrow
        )
      end

      it { is_expected.to eq 3 }
    end

    context 'when activities are not stopped' do
      before do
        create_list(
          :activity,
          3,
          started_at: now,
          stopped_at: nil
        )
      end

      it { is_expected.to be_zero }
    end
  end

  describe '#project_is_invalid' do
    subject(:instance) do
      activity = build(
        :activity,
        user: user,
        project: project
      )
      activity.valid?
      activity
    end

    let(:user) { create(:user) }

    context 'when project is nil' do
      let(:project) { nil }

      it { is_expected.to be_valid }
    end

    context 'when user has this project' do
      let(:project) { create(:project, user: user) }

      it { is_expected.to be_valid }
    end

    context 'when user does not have this project' do
      let(:project) { create(:project) }

      it { expect(instance.errors).to be_include :project }
    end
  end

  describe '#set_duration' do
    subject { activity.duration }

    let(:started_at) { Time.zone.now }
    let(:activity) do
      create(
        :activity,
        started_at: started_at,
        stopped_at: stopped_at
      )
    end

    context 'when stopped_at is nil' do
      let(:stopped_at) { nil }

      it { is_expected.to be_nil }
    end

    context 'when stopped_at is defined' do
      let(:stopped_at) { started_at.tomorrow }

      it { is_expected.to eq(60 * 60 * 24) }
    end

    context 'when stopped_at change to nil' do
      let(:stopped_at) { started_at.tomorrow }

      before { activity.update(stopped_at: nil) }

      it { is_expected.to be_nil }
    end

    context 'when stopped_at change to defined' do
      let(:stopped_at) { nil }

      before { activity.update(stopped_at: started_at.tomorrow) }

      it { is_expected.to eq(60 * 60 * 24) }
    end
  end

  describe '#stop_other_workings' do
    let(:users) { create_list(:user, 2) }

    around do |e|
      travel_to('2019-01-01 00:00:00') { e.run }
    end

    context 'when start activity twice' do
      before do
        create(:activity, user: users[0], stopped_at: nil)
        create(:activity, user: users[0], stopped_at: nil)
      end

      it 'stop first activity' do
        expect(users[0].activities.where(stopped_at: nil).count).to eq(1)
      end
    end

    context 'when start activity twice but different user' do
      before do
        create(:activity, user: users[0], stopped_at: nil)
        create(:activity, user: users[1], stopped_at: nil)
      end

      it 'does not stop any activities' do
        expect(users.flat_map(&:activities).map(&:stopped_at)).to eq([nil, nil])
      end
    end

    context 'when update activity but it is still working' do
      subject(:instance) { create(:activity, stopped_at: nil) }

      before { instance.update!(description: 'Review', stopped_at: nil) }

      it 'does not stop activity' do
        expect(instance.reload.stopped_at).to be_nil
      end
    end
  end

  describe '#suggestions' do
    subject(:suggestions) do
      described_class.suggestions(
        query: query,
        limit: limit
      )
    end

    let(:limit) { 50 }

    context 'when matched' do
      let(:query) { 'Rev' }

      before do
        create(:activity, description: 'Review1')
        create(:activity, description: 'Review2')
        create(:activity, description: 'Development')
      end

      it 'returns matched suggestions' do
        expect(suggestions.size).to be(2)
      end

      it 'returns matched suggestions in descending order of id' do
        expect(suggestions.map(&:description)).to eq %w[Review2 Review1]
      end
    end

    context 'when result size is greater than limit param' do
      let(:query) { 'Rev' }
      let(:limit) { 1 }

      before do
        create(:activity, description: 'Review1')
        create(:activity, description: 'Review2')
      end

      it 'limit results' do
        expect(suggestions.size).to be(1)
      end
    end

    context 'when query is blank' do
      let(:query) { '' }

      before { create_list(:activity, 3) }

      it 'returns all' do
        expect(suggestions.size).to be(3)
      end
    end
  end
end
