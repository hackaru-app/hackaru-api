# frozen_string_literal: true

module V1
  module Auth
    class RefreshTokensController < ApplicationController
      def create
        user = User.find_by(email: user_params[:email])
        singed_in = user&.authenticate(user_params[:password])
        return render_error_by_key :sign_in_failed unless singed_in

        sign_refresh_token(*RefreshToken.issue(user))
        render json: user
      end

      def destroy
        RefreshToken.verify(
          request.headers['X-Client-Id'],
          request.headers['X-Refresh-Token']
        )&.revoke
      end

      private

      def sign_refresh_token(refresh_token, raw)
        response.set_header('X-Client-Id', refresh_token.client_id)
        response.set_header('X-Refresh-Token', raw)
      end

      def user_params
        params.require(:user).permit(
          :email,
          :password
        )
      end
    end
  end
end
