# frozen_string_literal: true

require 'csv'

class ActivityCsv
  def initialize(activities, time_zone)
    @activities = activities
    @time_zone = time_zone
  end

  def generate_bom
    "\uFEFF#{generate}"
  end

  private

  def generate
    CSV.generate(force_quotes: true, headers: true) do |data|
      data << headers
      rows.each do |value|
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

  def rows
    @activities.map do |activity|
      [
        activity.id,
        activity.project&.id, activity.project&.name,
        activity.description,
        time_string(activity.started_at),
        time_string(activity.stopped_at),
        activity.duration
      ]
    end
  end

  def time_string(time)
    time&.in_time_zone(@time_zone)&.strftime('%F %T')
  end
end
