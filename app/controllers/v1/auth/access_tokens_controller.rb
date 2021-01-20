# frozen_string_literal: true

module V1
  module Auth
    class AccessTokensController < ApplicationController
      def create
        user = RefreshToken.fetch(client_id: client_id, raw: raw)&.user
        return render_error_by_key :refresh_token_invalid unless user

        response.set_header('X-Access-Token', AccessToken.new(user: user).issue)
        store_auth_token_if_needed(user)
        render json: user
      end

      private

      def store_auth_token_if_needed(user)
        return if cookies.signed[:auth_token_id] && cookies.signed[:auth_token_raw]

        store_auth_token(*AuthToken.issue!(user))
      end

      def client_id
        request.headers['X-Client-Id']
      end

      def raw
        request.headers['X-Refresh-Token']
      end
    end
  end
end
