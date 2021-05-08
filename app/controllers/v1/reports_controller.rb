# frozen_string_literal: true

module V1
  class ReportsController < ApplicationController
    include PdfRenderable
    include ActionController::MimeResponds
    include ActionController::Helpers

    helper :duration
    helper :webpack_url

    before_action :authenticate_user!

    def show
      @report = build_report
      respond_to do |format|
        format.html { render :show, formats: [:html], layout: 'pdf' }
        format.json { render json: ReportBlueprint.render(@report) }
        format.csv { send_data generate_csv(@report.activities), type: :csv }
        format.pdf { render_pdf :show }
      end
    end

    private

    def projects(ids)
      projects = current_user.projects
      ids ? projects.where(id: ids) : projects
    end

    def generate_csv(activities)
      ActivityCsv.new(activities, params[:time_zone]).generate_bom
    end

    def build_report
      report = Report.new(
        projects: projects(params[:project_ids]),
        start_date: params[:start],
        end_date: params[:end],
        time_zone: params[:time_zone]
      )
      report.valid!
      report
    end
  end
end
