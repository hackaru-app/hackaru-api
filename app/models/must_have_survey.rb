# frozen_string_literal: true

class MustHaveSurvey < ApplicationRecord
  belongs_to :user, optional: true

  validates :user_id, uniqueness: true
  validates :must_have_level, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 3 }
  validates :alternative_present, inclusion: { in: [true, false] }
  validates :alternative_detail, presence: true, if: :alternative_present?
  validates :alternative_detail, absence: true, unless: :alternative_present?
  validates :core_value, presence: true
  validates :recommended, inclusion: { in: [true, false] }
  validates :recommended_detail, presence: true, if: :recommended?
  validates :recommended_detail, absence: true, unless: :recommended?
  validates :target_user_detail, presence: true
  validates :feature_request, presence: true
  validates :interview_accept, inclusion: { in: [true, false] }
  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            length: { maximum: 191 }, if: :interview_accept?
  validates :email, absence: true, unless: :interview_accept?
  validates :locale, presence: true, inclusion: { in: :locales }

  def self.answerable?(user)
    user.must_have_survey.nil? &&
      user.created_at + 30.days <= Time.zone.now &&
      user.activities.count >= 10
  end

  private

  def locales
    I18n.available_locales.map(&:to_s)
  end
end
