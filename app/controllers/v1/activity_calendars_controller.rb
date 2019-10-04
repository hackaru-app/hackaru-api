# frozen_string_literal: true

module V1
  class ActivityCalendarsController < ApplicationController
    before_action :authenticate_user!, only: %i[update destroy]

    def update
      calendar = ActivityCalendar.find_or_create_by(user: current_user)
      render json: { user_id: current_user.id, token: calendar.token }
    end

    def show
      param! :user_id, String, required: true
      param! :token, String, required: true

      calendar = ActivityCalendar.find_by(user_id: params[:user_id])
      if calendar&.token == params[:token]
        return render plain: calendar.to_ical, content_type: 'text/calendar'
      end

      render_error_by_key(:activity_calendar_token_invalid)
    end

    def destroy
      current_user.activity_calendar&.destroy
    end
  end
end
