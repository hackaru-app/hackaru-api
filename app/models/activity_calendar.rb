# frozen_string_literal: true

class ActivityCalendar < ApplicationRecord
  has_secure_token :token

  belongs_to :user
  has_many :activities, through: :user

  def to_ical(limit:)
    calendar = Icalendar::Calendar.new
    calendar.append_custom_property('X-WR-CALNAME;VALUE=TEXT', 'Hackaru')
    target_activities = activities.includes(:project).order(started_at: :desc).limit(limit)
    build_events(target_activities).each { |event| calendar.add_event(event) }
    calendar.to_ical
  end

  private

  def build_events(target_activities)
    target_activities.map do |activity|
      ActivityEvent.new(activity).event
    end.compact
  end
end
