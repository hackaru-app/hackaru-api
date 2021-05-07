# frozen_string_literal: true

module V1
  class ProjectsController < ApplicationController
    before_action only: :index do
      authenticate_user! 'projects:read'
    end

    before_action only: %i[create update destroy] do
      authenticate_user! 'projects:write'
    end

    def index
      render json: ProjectBlueprint.render(current_user.projects)
    end

    def create
      project = current_user.projects.create!(project_params)
      render json: ProjectBlueprint.render(project)
    end

    def update
      project = current_user.projects.find(params[:id])
      project.update!(project_params)
      render json: ProjectBlueprint.render(project)
    end

    def destroy
      project = current_user.projects.find(params[:id])
      render json: ProjectBlueprint.render(project.destroy)
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
