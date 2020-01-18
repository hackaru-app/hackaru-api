# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSetting, type: :model do
  describe 'associations' do
    it { is_expected.to belongs_to(:user) }
  end

  describe 'validations' do
    subject { build(:user) }

    describe 'receive_weekly_report' do
      it { is_expected.to validate_presence_of(:receive_weekly_report) }
    end

    describe 'receive_monthly_report' do
      it { is_expected.to validate_presence_of(:receive_monthly_report) }
    end
  end
end
