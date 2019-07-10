# frozen_string_literal: true

module V1
  class SearchController < ApplicationController
    before_action :authenticate_user!

    def index
      param! :q, String
      render json: current_user
        .activities
        .search_by_description(params[:q])
        .order(created_at: :desc)
        .limit(50)
    end
  end
end
