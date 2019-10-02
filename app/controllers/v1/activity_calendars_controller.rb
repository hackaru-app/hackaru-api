# frozen_string_literal: true

module V1
  class ActivityCalendarsController < ApplicationController
    before_action :authenticate_user!

    def update
      calendar = ActivityCalendar.find_or_create_by(user: current_user)
      render json: { token: calendar.token }
    end

    def show
      calendar = current_user.activity_calendar
      if calendar&.token == params[:token]
        render plain: calendar.to_ical, content_type: 'text/calendar'
      else
        render_error_by_key(:activity_calendar_token_invalid)
      end
    end

    def destroy
      current_user.activity_calendar&.destroy
    end
  end
end
