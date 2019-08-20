# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  it_behaves_like 'webhookable'

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:activities).dependent(:nullify) }
  end

  describe 'validations' do
    subject { build(:project) }

    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }
    end

    describe 'color' do
      it { is_expected.to allow_value('#ffffff').for(:color) }
      it { is_expected.to allow_value('#fff').for(:color) }
      it { is_expected.to allow_value(nil).for(:color) }
      it { is_expected.not_to allow_value('#gggggg').for(:color) }
    end
  end
end
