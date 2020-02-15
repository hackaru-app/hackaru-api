# frozen_string_literal: true

class Activity < ApplicationRecord
  include Webhookable

  belongs_to :user
  belongs_to :project, optional: true

  validates :description, length: { maximum: 191 }
  validates :started_at, presence: true
  validates :started_at,
            date: { before_or_equal_to: :stopped_at }, if: :stopped?
  validate :project_is_invalid

  before_save :set_duration
  before_save :stop_other_workings, unless: :stopped?

  scope :between, lambda { |from, to|
    where('started_at <= ? and ? <= stopped_at', to, from)
  }

  scope :stopped, -> { where.not(duration: nil) }

  after_commit :deliver_stopped_webhooks, on: %i[update]

  def deliver_stopped_webhooks
    prevs = previous_changes[:stopped_at]
    return unless stopped_at && prevs && prevs.first.nil?

    deliver_webhooks 'stopped'
  end

  def set_duration
    self.duration = calc_duration
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

  def self.working
    find_by(stopped_at: nil)
  end

  private

  def calc_duration
    stopped_at ? stopped_at - started_at : nil
  end

  def stopped?
    stopped_at.present?
  end

  def project_is_invalid
    return if project_id.nil?
    return if user.projects.exists?(id: project_id)

    errors.add(:project, :is_invalid)
  end
end
