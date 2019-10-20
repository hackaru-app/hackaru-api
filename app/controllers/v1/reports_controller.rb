# frozen_string_literal: true

module V1
  class ReportsController < ApplicationController
    include PdfRenderable

    def show
      render_pdf :show
    end
  end
end
