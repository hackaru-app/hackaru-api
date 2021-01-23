# frozen_string_literal: true

module V1
  module Auth
    class AuthTokensController < ApplicationController
      before_action :validate_xhr!

      def create
        user = User.find_by(email: user_params[:email])
        singed_in = user&.authenticate(user_params[:password])
        return render_error_by_key :sign_in_failed unless singed_in

        store_auth_token(*AuthToken.issue!(user))
        render json: user
      end

      def destroy
        revoke_auth_token
      end

      private

      def user_params
        params.require(:user).permit(
          :email,
          :password
        )
      end
    end
  end
end
