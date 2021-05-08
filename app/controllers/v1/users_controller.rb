# frozen_string_literal: true

module V1
  class UsersController < ApplicationController
    before_action only: :show do
      authenticate_user! 'user:read'
    end

    before_action only: :update do
      authenticate_user!
    end

    def show
      render json: UserBlueprint.render(current_user)
    end

    def update
      current_user.update!(user_params)
      render json: UserBlueprint.render(current_user)
    end

    private

    def user_params
      params.require(:user).permit(
        :time_zone,
        :locale,
        :receive_week_report,
        :receive_month_report
      )
    end
  end
end
