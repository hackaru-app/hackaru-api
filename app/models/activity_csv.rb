# frozen_string_literal: true

require 'csv'

class ActivityCsv
  def initialize(activities)
    @activities = activities
  end

  def generate_bom
    "\uFEFF#{generate}"
  end

  private

  def generate
    csv = CSV.generate(force_quotes: true, headers: true) do |data|
      data << headers
      values.each do |value|
        data << value
      end
    end
  end

  def headers
    %i[
      id
      project_id
      project_name
      description
      started_at
      stopped_at
      duration
    ].map { |key| I18n.t(key, scope: 'activity_csv') }
  end

  def values
    @activities.map do |activity|
      [
        activity.id,
        activity.project&.id,
        activity.project&.name,
        activity.description,
        activity.started_at, activity.stopped_at,
        activity.duration
      ]
    end
  end
end
