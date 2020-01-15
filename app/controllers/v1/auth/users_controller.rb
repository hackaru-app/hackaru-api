# frozen_string_literal: true

module V1
  module Auth
    class UsersController < ApplicationController
      before_action only: %i[update destroy] do
        authenticate_user!
      end

      before_action only: %i[update destroy] do
        validate_current_password!
      end

      def create
        user = UserInitializer.new(user_params).create!
        sign_refresh_token(*RefreshToken.issue(user))
        UserMailer.sign_up(user).deliver_later
        render json: user
      end

      def update
        current_user.update!(user_params)
        render json: current_user
      end

      def destroy
        render json: current_user.destroy!
      end

      private

      def validate_current_password!
        current_password = params[:user][:current_password]
        valid = current_user.authenticate(current_password)
        render_error_by_key :current_password_invalid unless valid
      end

      def sign_refresh_token(refresh_token, raw)
        response.set_header('X-Client-Id', refresh_token.client_id)
        response.set_header('X-Refresh-Token', raw)
      end

      def user_params
        params.require(:user).permit(
          :email,
          :password,
          :password_confirmation
        )
      end
    end
  end
end
