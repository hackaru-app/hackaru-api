# frozen_string_literal: true

module V1
  class WebhooksController < ApplicationController
    before_action :authenticate_user!

    def index
      render json: current_user.webhooks
    end

    def create
      render json: current_user.webhooks.create!(webhook_params)
    end

    def update
      webhook = current_user.webhooks.find(params[:id])
      webhook.update!(webhook_params)
      render json: webhook
    end

    def destroy
      webhook = current_user.webhooks.find(params[:id])
      render json: webhook.destroy
    end

    private

    def webhook_params
      params.require(:webhook).permit(
        :target_url,
        :event
      )
    end
  end
end
