# frozen_string_literal: true

class ActivityEvent
  def initialize(activity)
    @activity = activity
  end

  def add_to_calendar(calendar)
    calendar.event do |e|
      e.dtstart = Icalendar::Values::DateTime.new(@activity.started_at)
      e.dtend = Icalendar::Values::DateTime.new(@activity.stopped_at)
      e.summary = Icalendar::Values::Text.new(summary)
    end
  end

  private

  def project_name
    @activity.project&.name || 'No Project'
  end

  def summary
    description = @activity.description
    description.present? ? description : project_name
  end
end
