# frozen_string_literal: true

module V1
  class ReportsController < ApplicationController
    include PdfRenderable
    include ActionController::MimeResponds

    before_action :authenticate_user!, only: :show

    def show
      @report = build_report
      @report.valid!
      respond_to do |format|
        format.html { render :show, formats: [:html] }
        format.pdf { render_pdf :show }
      end
    end

    private

    def build_report
      Report.new(
        user: current_user,
        start_date: params[:start],
        end_date: params[:end],
        period: params[:period],
        time_zone: params[:time_zone]
      )
    end
  end
end
