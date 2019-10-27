# frozen_string_literal: true

module V1
  class ReportsController < ApplicationController
    # include PdfRenderable
    # include ActionController::MimeResponds

    def show
      @report = build_report
      render json: @report
      # respond_to do |format|
      #   format.html { render :show, formats: [:html] }
      #   format.pdf { render_pdf :show }
      #   format.json { render json: @report }
      # end
    end

    private

    def build_report
      Report.new(
        user: User.find(1),
        date_start: params[:start],
        date_end: params[:end],
        period: params[:period],
        time_zone: params[:time_zone]
      )
    end
  end
end
