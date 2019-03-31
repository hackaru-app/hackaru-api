# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  it_behaves_like 'webhookable'

  describe 'validations' do
    subject do
      project.valid?
      project
    end

    context 'when name is empty' do
      let(:project) { build(:project, name: '') }
      it { expect(subject.errors).to be_include :name }
    end

    context 'when name is reserved' do
      let(:user) { create(:user) }
      let(:project) { build(:project, name: 'Review', user: user) }
      before { create(:project, name: 'Review', user: user) }
      it { expect(subject.errors).to be_include :name }
    end

    context 'when name is not unique but user is different' do
      let(:project) { build(:project, name: 'Review') }
      before { create(:project, name: 'Review') }
      it { is_expected.to be_valid }
    end

    context 'when color hex is invalid' do
      let(:project) { build(:project, color: '#gggggg') }
      it { expect(subject.errors).to be_include :color }
    end

    context 'when color hex is short format' do
      let(:project) { build(:project, color: '#fff') }
      it { is_expected.to be_valid }
    end

    context 'when color hex is nil' do
      let(:project) { build(:project, color: nil) }
      it { is_expected.to be_valid }
    end
  end
end
