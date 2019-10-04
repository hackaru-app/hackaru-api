# frozen_string_literal: true

class ActivityEvent
  def initialize(activity)
    @activity = activity
  end

  def event
    event = Icalendar::Event.new
    event.dtstart = Icalendar::Values::DateTime.new(@activity.started_at)
    event.dtend = Icalendar::Values::DateTime.new(@activity.stopped_at)
    event.summary = Icalendar::Values::Text.new(summary)
    event
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
