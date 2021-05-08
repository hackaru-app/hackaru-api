# frozen_string_literal: true

module V1
  class SuggestionsController < ApplicationController
    before_action only: :index do
      authenticate_user! 'suggestions:read'
    end

    def index
      param! :q, String, default: ''
      param! :limit, Integer, range: 0..100, default: 50

      activities = current_user.activities
      suggestions = activities.suggestions(query: params[:q], limit: params[:limit])
      render json: SuggestionBlueprint.render(suggestions)
    end
  end
end
