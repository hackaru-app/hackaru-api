# frozen_string_literal: true

class ActivityCalendar
  def initialize(activities)
    @calendar = Icalendar::Calendar.new
    @calendar.append_custom_property('X-WR-CALNAME;VALUE=TEXT', 'Hackaru')
    add_events(activities)
  end

  def to_ical
    @calendar.to_ical
  end

  private

  def add_events(activities)
    activities.includes(:project).each do |activity|
      ActivityEvent.new(activity).add_to_calendar(@calendar)
    end
  end
end
