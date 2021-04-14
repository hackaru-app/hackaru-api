# frozen_string_literal: true

module V1
  module Auth
    class PasswordResetsController < V1::Auth::ApplicationController
      def mails
        user = User.find_by(email: user_params[:email])
        return render_api_error_of :email_not_found unless user

        UserMailer.password_reset(user).deliver_later
      end

      def update
        User.find(password_reset_params[:id]).reset_password(
          token: password_reset_params[:token],
          password: password_reset_params[:password],
          password_confirmation: password_reset_params[:password_confirmation]
        ) || render_api_error_of(:password_reset_token_invalid)
      end

      private

      def user_params
        params.require(:user).permit(:email)
      end

      def password_reset_params
        params.require(:user).permit(
          :id,
          :password,
          :password_confirmation,
          :token
        )
      end
    end
  end
end
