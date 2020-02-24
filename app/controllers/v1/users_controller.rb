# frozen_string_literal: true

module V1
  class UsersController < ApplicationController
    before_action :authenticate_user!

    def show
      render json: current_user
    end

    def update
      current_user.update!(user_params)
      render json: current_user
    end

    private

    def user_params
      params.require(:user).permit(
        :time_zone,
        :locale,
        :receive_week_report,
        :receive_month_report,
        :receive_reminder
      )
    end
  end
end
