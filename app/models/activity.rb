# frozen_string_literal: true

class Activity < ApplicationRecord
  include Webhookable

  belongs_to :user
  belongs_to :project, optional: true

  validates :started_at, presence: true
  validate :project_is_invalid
  validate :stopped_at_cannot_be_before_started_at

  before_save :set_duration
  before_save :stop_working_activities, unless: -> { stopped_at.present? }

  scope :working, -> { where(stopped_at: nil) }
  scope :search_by_description, lambda { |q|
    where('description like ?', "%#{q}%")
  }
  scope :between, lambda { |from, to|
    where('started_at <= ? and ? <= stopped_at', to, from) if from && to
  }

  after_commit :deliver_stopped_webhooks, on: %i[update]

  def deliver_stopped_webhooks
    prevs = previous_changes[:stopped_at]
    return unless stopped_at.present? && prevs.present? && prevs.first.nil?

    deliver_webhooks 'stopped'
  end

  def project_is_invalid
    return if project_id.nil?
    return if user.projects.exists?(id: project_id)

    errors.add(:project, :is_invalid)
  end

  def stopped_at_cannot_be_before_started_at
    return if started_at.nil? || stopped_at.nil?
    return if stopped_at >= started_at

    errors.add(:stopped_at, :cannot_be_before_started_at)
  end

  def set_duration
    self.duration = stopped_at.present? ? stopped_at - started_at : nil
  end

  def stop_working_activities
    user.activities.working.update(stopped_at: Time.zone.now)
  end
end
