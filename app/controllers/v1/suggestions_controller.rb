# frozen_string_literal: true

module V1
  class SuggestionsController < ApplicationController
    before_action only: %i[index] do
      authenticate_user_or_doorkeeper! 'suggestions:read'
    end

    def index
      param! :q, String, required: true
      render json: current_user.activities.suggestions_by(params[:q])
    end
  end
end
