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

      calendar = ActivityCalendar.find_by(user_id: params[:user_id])
      if calendar&.token == params[:token]
        render plain: calendar.to_ical, content_type: 'text/calendar'
      else
        render_api_error_of :activity_calendar_token_invalid
      end
    end

    def destroy
      current_user.activity_calendar&.destroy
    end
  end
end
