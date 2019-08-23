# frozen_string_literal: true

module V1
  module Auth
    class AccessTokensController < ApplicationController
      def create
        user = RefreshToken.fetch(client_id: client_id, raw: raw)&.user
        return render_error_by_key :refresh_token_invalid unless user

        response.set_header('X-Access-Token', AccessToken.new(user: user).issue)
        render json: user
      end

      private

      def client_id
        request.headers['X-Client-Id']
      end

      def raw
        request.headers['X-Refresh-Token']
      end
    end
  end
end
