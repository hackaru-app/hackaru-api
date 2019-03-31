# frozen_string_literal: true

module V1
  module OAuth
    class AuthorizedApplicationsController < ApplicationController
      before_action :authenticate_user!

      def index
        applications = Doorkeeper::Application.authorized_for(current_user)
        render json: applications, except: :secret
      end

      def destroy
        Doorkeeper::Application.revoke_tokens_and_grants_for(
          params[:id],
          current_user
        )
        render status: 204
      end
    end
  end
end
