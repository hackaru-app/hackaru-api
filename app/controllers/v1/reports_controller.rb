# frozen_string_literal: true

module V1
  class ReportsController < ApplicationController
    include PdfRenderable
    include ActionController::MimeResponds

    def show
      respond_to do |format|
        format.html { render :show, formats: [:html] }
        format.pdf { render_pdf :show }
      end
    end
  end
end
