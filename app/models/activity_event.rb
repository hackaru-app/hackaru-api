# frozen_string_literal: true

class ActivityEvent
  def initialize(activity)
    @activity = activity
  end

  def event
    event = Icalendar::Event.new
    event.dtstart = to_datetime_value(@activity.started_at)
    event.dtend = to_datetime_value(@activity.stopped_at)
    event.summary = Icalendar::Values::Text.new(summary)
    event
  end

  private

  def to_datetime_value(datetime)
    Icalendar::Values::DateTime.new(datetime, tzid: 'UTC')
  end

  def project_name
    @activity.project&.name || 'No Project'
  end

  def summary
    description = @activity.description
    description.present? ? description : project_name
  end
end
