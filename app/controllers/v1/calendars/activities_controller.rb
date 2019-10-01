# frozen_string_literal: true

module V1
  module Calendars
    class ActivitiesController < ApplicationController
      # before_action :authenticate_user!

      def index
        user = User.find(2)
        render plain: ActivityCalendar.new(user.activities).to_ical,
               content_type: 'text/calendar'
      end
    end
  end
end
