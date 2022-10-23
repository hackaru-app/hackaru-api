# frozen_string_literal: true

module V1
  class ActivityCalendarsController < ApplicationController
    before_action only: %i[update destroy] do
      authenticate_user!
    end

    def update
      activity_calendar = ActivityCalendar.find_or_create_by(user: current_user)
      render json: ActivityCalendarBlueprint.render(activity_calendar)
    end

    def show
      param! :user_id, Integer, required: true
      param! :token, String, required: true

      calendar = Icalendar::Calendar.new
      calendar.append_custom_property('X-WR-CALNAME;VALUE=TEXT', 'Hackaru')
      render plain: calendar.to_ical, content_type: 'text/calendar'
    end

    def destroy
      current_user.activity_calendar&.destroy
    end
  end
end
