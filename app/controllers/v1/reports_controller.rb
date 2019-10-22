# frozen_string_literal: true

module V1
  class ReportsController < ApplicationController
    include PdfRenderable
    include ActionController::MimeResponds

    def show
      param! :start, Time, required: true
      param! :end, Time, required: true

      @start = params[:start]
      @end = params[:end]
      @projects = User.find(1).projects # TODO

      respond_to do |format|
        format.html { render :show, formats: [:html] }
        format.pdf { render_pdf :show }
      end
    end
  end
end
