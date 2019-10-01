# frozen_string_literal: true

class ActivityCalendar
  def initialize(activities)
    @calendar = Icalendar::Calendar.new
    @calendar.append_custom_property('X-WR-CALNAME;VALUE=TEXT', 'Hackaru')
    activities.each { |activity| add_event(activity) }
  end

  def to_ical
    @calendar.to_ical
  end

  private

  def add_event(activity)
    @calendar.event do |e|
      e.dtstart = Icalendar::Values::DateTime.new(activity.started_at)
      e.dtend = Icalendar::Values::DateTime.new(activity.stopped_at)
      e.summary = Icalendar::Values::Text.new(
        activity.description || activity.project&.name
      )
    end
  end
end
