# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExceptionRenderer, type: :model do
  describe '#initialize' do
    subject(:instance) { described_class.new(exception) }

    context 'when occurred routing exception' do
      let(:exception) { ActionController::RoutingError.new 'error' }

      it { expect(instance.message).not_to be_nil }
      it { expect(instance.status).to eq 404 }
    end

    context 'when occurred custom exception' do
      let(:exception) { StandardError.new }

      it { expect(instance.message).not_to be_nil }
      it { expect(instance.status).to eq 500 }
    end

    context 'when occurred validate exception' do
      let(:mock_model) do
        Class.new do
          include ActiveModel::Model
          attr_reader :attr

          validates :attr, presence: true

          def self.name
            'mock_model'
          end
        end
      end

      let(:exception) do
        record = mock_model.new
        record.valid?
        ActiveRecord::RecordInvalid.new(record)
      end

      it 'returns instance with first message' do
        first = exception.record.errors.full_messages.first
        expect(instance.message).to eq first
      end

      it 'returns instance with status' do
        expect(instance.status).to eq 422
      end
    end
  end
end
