# frozen_string_literal: true

module V1
  class UsersController < ApplicationController
    before_action only: %i[update] do
      authenticate_user!
    end

    def update
      current_user.update!(user_params)
      render json: current_user
    end

    private

    def user_params
      params.require(:user).permit(
        :receive_week_report,
        :receive_month_report
      )
    end
  end
end
