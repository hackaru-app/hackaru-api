# frozen_string_literal: true

module V1
  class ActivitiesController < ApplicationController
    before_action only: %i[index working] do
      authenticate_user! 'activities:read'
    end

    before_action only: %i[create update destroy] do
      authenticate_user! 'activities:write'
    end

    def index
      param! :start, Time, required: true
      param! :end, Time, required: true

      render json: ActivityBlueprint.render(
        current_user
          .activities
          .includes(:project)
          .between(params[:start], params[:end])
      )
    end

    def working
      activity = current_user.activities.find_by(stopped_at: nil)
      render json: activity ? ActivityBlueprint.render(activity) : nil
    end

    def create
      activity = current_user.activities.create!(activity_params)
      render json: ActivityBlueprint.render(activity)
    end

    def update
      activity = current_user.activities.find(params[:id])
      activity.update!(activity_params)
      render json: ActivityBlueprint.render(activity)
    end

    def destroy
      activity = current_user.activities.find(params[:id])
      render json: ActivityBlueprint.render(activity.destroy)
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
