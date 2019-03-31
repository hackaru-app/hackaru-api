# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExceptionRenderer, type: :model do
  describe '#initialize' do
    subject { ExceptionRenderer.new(exception) }

    context 'when occurred routing exception' do
      let(:exception) { ActionController::RoutingError.new 'error' }
      it { expect(subject.message).not_to be_nil }
      it { expect(subject.status).to eq 404 }
    end

    context 'when occurred custom exception' do
      let(:exception) { class UnknownError < StandardError; end }
      it { expect(subject.message).not_to be_nil }
      it { expect(subject.status).to eq 500 }
    end

    context 'when occurred validate exception' do
      before do
        class MockModel
          include ActiveModel::Model
          attr_accessor :attr
          validates :attr, presence: true
        end
      end

      let(:exception) do
        record = MockModel.new
        record.valid?
        ActiveRecord::RecordInvalid.new(record)
      end

      it 'returns first message' do
        first = exception.record.errors.full_messages.first
        expect(subject.message).to eq first
        expect(subject.status).to eq 422
      end
    end
  end
end
