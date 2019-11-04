# frozen_string_literal: true

module V1
  class ReportsController < HtmlApplicationController
    include PdfRenderable
    include ActionController::MimeResponds

    before_action :authenticate_user!, only: :show

    def show
      @report = build_report
      set_show_variables

      respond_to do |format|
        format.html { render :show, formats: [:html] }
        format.json { render json: @report }
        format.pdf { render_pdf :show }
      end
    end

    private

    def set_show_variables
      gon.push(
        bar_chart_data: @report.bar_chart_data,
        totals: @report.totals.to_a,
        colors: @report.colors,
        labels: @report.labels
      )
    end

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
