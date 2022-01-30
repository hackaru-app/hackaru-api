# frozen_string_literal: true

require 'rails_helper'

describe OwnerValidator, type: :validator do
  let(:user) do
    Struct.new(:id)
  end

  let(:value) do
    Struct.new(:owner) do
      def class_name
        'Value'
      end
    end
  end

  let(:resource) do
    Struct.new(:value, :owner) do
      include ActiveModel::Validations
      validates :value, owner: { model: :owner }
    end
  end

  describe '#validate_each' do
    context 'when owner is matched' do
      subject { resource.new(value.new(user.new(1)), user.new(1)) }

      it { is_expected.to be_valid }
    end

    context 'when owner is unmatched' do
      subject { resource.new(value.new(user.new(1)), user.new(2)) }

      it { is_expected.to be_invalid }
    end

    context 'when value is nil' do
      subject { resource.new(nil, user.new(1)) }

      it { is_expected.to be_invalid }
    end

    context 'when value owner is nil' do
      subject { resource.new(value.new(nil), user.new(1)) }

      it { is_expected.to be_invalid }
    end

    context 'when resource owner is nil' do
      subject { resource.new(value.new(user.new(1)), nil) }

      it { is_expected.to be_invalid }
    end

    context 'when both owners are nil' do
      subject { resource.new(value.new(nil), nil) }

      it { is_expected.to be_invalid }
    end

    context 'when value and resource owner are nil' do
      subject { resource.new(nil, nil) }

      it { is_expected.to be_invalid }
    end
  end
end
