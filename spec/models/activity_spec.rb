# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Activity, type: :model do
  it_behaves_like 'webhookable'

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:project).optional }
  end

  describe 'validations' do
    subject { build(:activity) }

    describe 'started_at' do
      it { should validate_presence_of(:started_at) }
    end

    describe 'description' do
      it { is_expected.to validate_length_of(:description).is_at_most(500) }
    end
  end

  describe 'scope' do
    describe '.between' do
      let(:now) { Time.now }
      subject { Activity.between(now - 3.days, now - 1.days).size }

      context 'when activities are contained' do
        before do
          create(:activity, started_at: now - 3.days, stopped_at: now)
          create(:activity, started_at: now - 3.days, stopped_at: now - 2.days)
          create(:activity, started_at: now - 6.days, stopped_at: now - 2.days)
          create(:activity, started_at: now - 3.days, stopped_at: now - 1.days)
        end
        it { is_expected.to eq 4 }
      end

      context 'when activities are not contained' do
        before do
          create(:activity, started_at: now - 6.days, stopped_at: now - 5.days)
          create(:activity, started_at: now + 1.days, stopped_at: now + 2.days)
        end
        it { is_expected.to be_zero }
      end

      context 'when \'from\' parameter is nil' do
        subject { Activity.between(nil, now) }
        before { create_list(:activity, 3) }
        it { is_expected.to be_empty }
      end

      context 'when \'to\' parameter is nil' do
        subject { Activity.between(now, nil) }
        before { create_list(:activity, 3) }
        it { is_expected.to be_empty }
      end
    end
  end

  describe '#deliver_stopped_webhooks' do
    subject { create(:activity, stopped_at: stopped_at) }

    before do
      allow(subject).to receive(:deliver_webhooks)
      subject.update(stopped_at: Time.now)
    end

    context 'when activity was working' do
      let(:stopped_at) { nil }
      it { is_expected.to have_received(:deliver_webhooks).with('stopped') }
    end

    context 'when activity was stopped' do
      let(:stopped_at) { 1.day.ago }
      it { is_expected.not_to have_received(:deliver_webhooks).with('stopped') }
    end
  end

  describe '#project_is_invalid' do
    let(:user) { create(:user) }

    subject do
      activity = build(
        :activity,
        user: user,
        project: project
      )
      activity.valid?
      activity
    end

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
      it { expect(subject.errors).to be_include :project }
    end
  end

  describe '#stopped_at_cannot_be_before_started_at' do
    let(:started_at) { Time.now }

    subject do
      activity = build(
        :activity,
        started_at: started_at,
        stopped_at: stopped_at
      )
      activity.valid?
      activity
    end

    context 'when started_at < stopped_at' do
      let(:stopped_at) { Time.now.tomorrow }
      it { is_expected.to be_valid }
    end

    context 'when started_at = stopped_at' do
      let(:stopped_at) { started_at }
      it { is_expected.to be_valid }
    end

    context 'when started_at > stopped_at' do
      let(:stopped_at) { 1.day.ago }
      it { expect(subject.errors).to be_include :stopped_at }
    end

    context 'when stopped_at is nil' do
      let(:stopped_at) { nil }
      it { is_expected.to be_valid }
    end
  end

  describe '#set_duration' do
    let(:started_at) { Time.now }
    let(:activity) do
      create(
        :activity,
        started_at: started_at,
        stopped_at: stopped_at
      )
    end

    subject { activity.duration }

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
  end

  describe '#stop_other_workings' do
    let(:users) { create_list(:user, 2) }

    around do |e|
      travel_to('2019-01-01 00:00:00'.to_time) { e.run }
    end

    context 'when start activity twice' do
      before do
        create(:activity, user: users[0], stopped_at: nil)
        create(:activity, user: users[0], stopped_at: nil)
      end

      it 'stop first activity' do
        expect(users[0].activities[0].stopped_at).to eq('2019-01-01 00:00:00')
      end

      it 'doest not stop second activity' do
        expect(users[0].activities[1].stopped_at).to be(nil)
      end
    end

    context 'when start activity twice but diffrent user' do
      before do
        create(:activity, user: users[0], stopped_at: nil)
        create(:activity, user: users[1], stopped_at: nil)
      end

      it 'does not stop any activities' do
        expect(users[0].activities[0].stopped_at).to be(nil)
        expect(users[1].activities[0].stopped_at).to be(nil)
      end
    end

    context 'when update activity but it is still working' do
      subject { create(:activity, stopped_at: nil) }
      before { subject.update!(description: 'Review', stopped_at: nil) }

      it 'does not stop activity' do
        expect(subject.reload.stopped_at).to be(nil)
      end
    end
  end

  describe '#to_suggestion' do
    let(:activity) { build(:activity) }
    subject { activity.to_suggestion }
    it { is_expected.to be_kind_of Suggestion }
    it { expect(subject.project).to be activity.project }
    it { expect(subject.description).to be activity.description }
  end

  describe '.working' do
    subject { described_class.working }

    context 'when activity is not stopped' do
      before { create(:activity, stopped_at: nil) }
      it { is_expected.not_to be_nil }
    end

    context 'when activity is stopped' do
      before { create(:activity, stopped_at: Time.now) }
      it { is_expected.to be_nil }
    end
  end

  describe '.to_suggestions' do
    before { create(:activity) }
    subject { described_class.to_suggestions }

    it 'convert to suggestions' do
      expect(subject.size).to be(1)
      expect(subject.first).to be_kind_of Suggestion
    end
  end
end
