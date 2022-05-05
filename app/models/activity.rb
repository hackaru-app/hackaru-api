# frozen_string_literal: true

class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :project, optional: true

  validates :description, length: { maximum: 191 }
  validates :started_at, presence: true
  validates :project, owner: { model: :user }, if: :project_id

  with_options if: :stopped_at do
    validates_datetime :started_at, on_or_before: :stopped_at
    validates_datetime :stopped_at, on_or_before: -> { _1.started_at.next_year }
  end

  with_options unless: :stopped_at do
    validates_datetime :started_at, on_or_before: -> { Time.now }
  end

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
end
