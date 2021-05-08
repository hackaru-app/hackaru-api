# frozen_string_literal: true

module Auth
  class UsersController < Auth::ApplicationController
    before_action only: %i[update destroy] do
      authenticate_user!
    end

    before_action only: %i[update destroy] do
      validate_current_password!
    end

    def create
      user = UserInitializer.new(user_params).create!
      store_auth_token(*AuthToken.issue!(user))
      UserMailer.sign_up(user).deliver_later
      render json: UserBlueprint.render(user)
    end

    def update
      current_user.update!(user_params)
      render json: UserBlueprint.render(current_user)
    end

    def destroy
      revoke_auth_token
      render json: UserBlueprint.render(current_user.destroy!)
    end

    private

    def validate_current_password!
      current_password = params.dig(:user, :current_password)
      valid = current_user.authenticate(current_password)
      render_api_error_of :current_password_invalid unless valid
    end

    def user_params
      params.require(:user).permit(
        :email,
        :password,
        :password_confirmation,
        :time_zone,
        :locale
      )
    end
  end
end
