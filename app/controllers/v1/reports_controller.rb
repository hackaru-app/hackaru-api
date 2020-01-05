# frozen_string_literal: true

module V1
  class ReportsController < HtmlApplicationController
    include PdfRenderable
    include ActionController::MimeResponds

    before_action :authenticate_user!, only: :show

    def show
      @report = build_report
      respond_to do |format|
        format.html { render :show, formats: [:html], layout: 'pdf' }
        format.json { render json: @report }
        format.pdf { render_pdf :show }
      end
    end

    private

    def build_report
      report = Report.new(
        user: current_user,
        start_date: params[:start],
        end_date: params[:end],
        time_zone: params[:time_zone]
      )
      report.valid!
      report
    end
  end
end
