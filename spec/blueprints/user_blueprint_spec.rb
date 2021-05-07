# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserBlueprint, type: :blueprint do
  describe '#to_json' do
    subject(:json) do
      described_class.render(user)
    end

    let(:user) { create(:user) }
    let(:expected_json) do
      {
        id: user.id,
        email: user.email,
        time_zone: user.time_zone,
        locale: user.locale,
        receive_week_report: user.receive_week_report,
        receive_month_report: user.receive_month_report
      }.to_json
    end

    it 'returns json' do
      expect(json).to be_json_eql(expected_json)
    end
  end
end
