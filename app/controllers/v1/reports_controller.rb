# frozen_string_literal: true

module V1
  class ReportsController < ApplicationController
    before_action :authenticate_user!

    def index
      param! :start, Time, required: true
      param! :end, Time, required: true
      param! :period, String, required: true
      param! :time_zone, String

      render json: Report.new(
        current_user,
        params[:start]..params[:end],
        params[:period],
        params[:time_zone]
      )
    end
  end
end
