# frozen_string_literal: true

class ActivityCalendar < ApplicationRecord
  has_secure_token :token

  belongs_to :user
  has_many :activities, through: :user

  def to_ical
    calendar = Icalendar::Calendar.new
    calendar.append_custom_property('X-WR-CALNAME;VALUE=TEXT', 'Hackaru')
    events.each { |event| calendar.add_event(event) }
    calendar.to_ical
  end

  private

  def events
    activities.includes(:project).map do |activity|
      ActivityEvent.new(activity).event
    end
  end
end
