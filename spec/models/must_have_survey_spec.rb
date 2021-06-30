# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MustHaveSurvey, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user).optional }
  end

  describe 'validations' do
    subject { build(:must_have_survey) }

    it { is_expected.to validate_numericality_of(:must_have_level).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:must_have_level).is_less_than_or_equal_to(3) }
    it { is_expected.to validate_presence_of(:core_value) }
    it { is_expected.to validate_presence_of(:target_user_detail) }
    it { is_expected.to validate_presence_of(:feature_request) }

    context 'when alternative_present is true' do
      subject { build(:must_have_survey, alternative_present: true) }

      it { is_expected.to validate_presence_of(:alternative_detail) }
    end

    context 'when alternative_present is false' do
      subject { build(:must_have_survey, alternative_present: false) }

      it { is_expected.to validate_absence_of(:alternative_detail) }
    end

    context 'when recommended is true' do
      subject { build(:must_have_survey, recommended: true) }

      it { is_expected.to validate_presence_of(:recommended_detail) }
    end

    context 'when recommended is false' do
      subject { build(:must_have_survey, recommended: false) }

      it { is_expected.to validate_absence_of(:recommended_detail) }
    end

    context 'when interview_accept is true' do
      subject { build(:must_have_survey, interview_accept: true) }

      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_length_of(:email).is_at_most(191) }
      it { is_expected.to allow_value('test@example.com').for(:email) }
      it { is_expected.not_to allow_value('invalid').for(:email) }
    end

    context 'when interview_accept is false' do
      subject { build(:must_have_survey, interview_accept: false) }

      it { is_expected.to validate_absence_of(:email) }
    end

    describe 'locale' do
      let(:array) { I18n.available_locales.map(&:to_s) }

      it { is_expected.to validate_inclusion_of(:locale).in_array(array) }
    end
  end

  describe '.answerable?' do
    subject do
      described_class.answerable?(user)
    end

    context 'when user signed up 30 days ago and user has enough activities' do
      let(:user) { create(:user, created_at: Time.zone.now - 30.days) }

      before { create_list(:activity, 10, user: user) }

      it { is_expected.to eq(true) }
    end

    context 'when user signed up 29 days ago and user has enough activities' do
      let(:user) { create(:user, created_at: Time.zone.now - 29.days) }

      before { create_list(:activity, 10, user: user) }

      it { is_expected.to eq(false) }
    end

    context 'when user signed up 30 days ago and user does not have enough activities' do
      let(:user) { create(:user, created_at: Time.zone.now - 30.days) }

      before { create_list(:activity, 9, user: user) }

      it { is_expected.to eq(false) }
    end

    context 'when user has already answered' do
      let(:user) { create(:user, created_at: Time.zone.now - 30.days) }

      before do
        create_list(:activity, 10, user: user)
        create(:must_have_survey, user: user)
      end

      it { is_expected.to eq(false) }
    end
  end
end
