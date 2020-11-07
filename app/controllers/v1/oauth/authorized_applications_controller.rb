# frozen_string_literal: true

module V1
  module OAuth
    class AuthorizedApplicationsController < ApplicationController
      before_action :authenticate_user!

      def index
        applications = Doorkeeper::Application.authorized_for(current_user)
        hash = applications.map do |application|
          {
            id: application.id,
            name: application.name,
            scopes: application.scopes,
            created_at: application.created_at,
          }
        end
        render json: hash
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
