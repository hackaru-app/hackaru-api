# frozen_string_literal: true

module V1
  class ActivitiesController < ApplicationController
    before_action only: %i[index working] do
      authenticate_user_or_doorkeeper! 'activities:read'
    end

    before_action only: %i[create update destroy] do
      authenticate_user_or_doorkeeper! 'activities:write'
    end

    def index
      param! :working, :boolean
      param! :start, Time
      param! :end, Time
      activities = current_user.activities
      activities = activities.working if params[:working] # TODO: remove it
      activities = activities.between(params[:start], params[:end])
      render json: activities
    end

    def working
      render json: current_user.activities.working
    end

    def create
      render json: current_user.activities.create!(activity_params)
    end

    def update
      activity = current_user.activities.find(params[:id])
      activity.update!(activity_params)
      render json: activity
    end

    def destroy
      activity = current_user.activities.find(params[:id])
      render json: activity.destroy
    end

    private

    def activity_params
      params.require(:activity).permit(
        :project_id,
        :description,
        :started_at,
        :stopped_at
      )
    end
  end
end
