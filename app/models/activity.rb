# frozen_string_literal: true

class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :project, optional: true

  validates :description, length: { maximum: 191 }
  validates :started_at, presence: true
  validate :project_is_invalid, if: :project_id

  validates :started_at, date: {
    before_or_equal_to: :stopped_at
  }, if: :stopped_at

  validates :stopped_at, date: {
    before_or_equal_to: proc { |obj| obj.started_at.next_year }
  }, if: %i[started_at stopped_at]

  before_save :set_duration
  before_save :stop_other_workings, unless: :stopped_at

  scope :between, lambda { |from, to|
    where('started_at <= ? and ? <= stopped_at', to, from)
  }

  scope :stopped, -> { where.not(duration: nil) }

  def set_duration
    self.duration = stopped_at ? stopped_at - started_at : nil
  end

  def stop_other_workings
    workings = user.activities.where(stopped_at: nil)
    workings.where.not(id: id).update(stopped_at: Time.zone.now)
  end

  def to_suggestion
    Suggestion.new(
      project: project,
      description: description
    )
  end

  def self.suggestions(query:, limit:)
    ids = ransack(description_cont: query)
          .result
          .select('maximum_id')
          .order('maximum_id desc')
          .group(:project_id, :description)
          .limit(limit)
          .maximum(:id)
          .values
    where(id: ids).order(id: :desc).includes(:project).map(&:to_suggestion)
  end

  private

  def project_is_invalid
    return if user.projects.exists?(id: project_id)

    errors.add(:project, :is_invalid)
  end
end
