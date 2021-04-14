# frozen_string_literal: true

module V1
  module OAuth
    class ApplicationsController < ApplicationController
      before_action :validate_xhr!

      def create
        application = Doorkeeper::Application.create!(application_params)
        render json: {
          web_url: ENV.fetch('HACKARU_WEB_URL'),
          application: {
            uid: application.uid,
            secret: application.secret
          }
        }
      end

      def application_params
        params.require(:application).permit(
          :name,
          :redirect_uri,
          :scopes
        )
      end
    end
  end
end
