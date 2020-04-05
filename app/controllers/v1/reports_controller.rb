# frozen_string_literal: true

module V1
  class ReportsController < HtmlApplicationController
    include PdfRenderable
    include ActionController::MimeResponds

    before_action :authenticate_user!

    def show
      @report = build_report
      respond_to do |format|
        format.html { render :show, formats: [:html], layout: 'pdf' }
        format.json { render json: @report }
        format.csv { send_data generate_csv(@report.activities), type: :csv }
        format.pdf { render_pdf :show }
      end
    end

    private

    def projects
      current_user.projects.where(id: params[:project_ids])
    end

    def generate_csv(activities)
      ActivityCsv.new(activities, params[:time_zone]).generate_bom
    end

    def build_report
      report = Report.new(
        projects: projects,
        start_date: params[:start],
        end_date: params[:end],
        time_zone: params[:time_zone]
      )
      report.valid!
      report
    end
  end
end
