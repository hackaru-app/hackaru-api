# frozen_string_literal: true

module V1
  module Auth
    class AccessTokensController < ApplicationController
      def create
        user = RefreshToken.verify(
          request.headers['X-Client-Id'],
          request.headers['X-Refresh-Token']
        )&.user
        return render_error_by_key :refresh_token_invalid unless user

        response.set_header('X-Access-Token', AccessToken.new(user).issue)
        render json: user
      end
    end
  end
end
