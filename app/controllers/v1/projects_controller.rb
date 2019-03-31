# frozen_string_literal: true

module V1
  class ProjectsController < ApplicationController
    before_action only: :index do
      authenticate_user_or_doorkeeper! 'projects:read'
    end

    before_action only: %i[create update destroy] do
      authenticate_user_or_doorkeeper! 'projects:write'
    end

    def index
      render json: current_user.projects
    end

    def create
      render json: current_user.projects.create!(project_params)
    end

    def update
      project = current_user.projects.find(params[:id])
      project.update!(project_params)
      render json: project
    end

    def destroy
      project = current_user.projects.find(params[:id])
      render json: project.destroy
    end

    private

    def project_params
      params.require(:project).permit(
        :name,
        :color
      )
    end
  end
end
