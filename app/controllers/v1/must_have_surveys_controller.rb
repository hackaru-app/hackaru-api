# frozen_string_literal: true

module V1
  class MustHaveSurveysController < ApplicationController
    before_action :authenticate_user!

    def answerable
      render json: { answerable: MustHaveSurvey.answerable?(current_user) }
    end

    def create
      MustHaveSurvey.create!(must_have_survey_params)
      render :success
    end

    private

    def must_have_survey_params # rubocop:disable Metrics/MethodLength
      params.require(:must_have_survey).permit(
        :must_have_level,
        :alternative_present,
        :alternative_detail,
        :core_value,
        :recommended,
        :recommended_detail,
        :target_user_detail,
        :feature_request,
        :interview_accept,
        :email,
        :locale
      ).merge(user: current_user)
    end
  end
end
