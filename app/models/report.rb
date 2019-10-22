# frozen_string_literal: true

class Report
  include ActiveModel::Model
  include ActiveModel::Attributes

  PERIODS = %w[hour day month].freeze

  attribute :user_id, :integer
  attribute :date_start, :datetime
  attribute :date_end, :datetime
  attribute :period, :string
  attribute :time_zone, :string

  validates :user_id, presence: true
  validates :start, presence: true
  validates :end, presence: true
  validates :period, inclusion: { in: PERIODS }, presence: true

  def summary
    projects
      .joins(:activities)
      .group(:id)
      .sum(:duration)
  end

  def summary_by_period
    projects
      .joins(:activities)
      .group(:id)
      .group_by_period(
        period,
        :started_at,
        time_zone: time_zone,
        permit: PERIODS,
        range: range
      )
      .sum(:duration)
  end

  def projects
    user.projects
  end

  private

  def range
    date_start..date_end
  end

  def user
    User.find(user_id)
  end
end
