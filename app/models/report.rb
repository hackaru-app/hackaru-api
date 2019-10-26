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
  attribute :user

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

  def donut_chart
    { columns: summary.to_a, colors: colors }
  end

  def bar_chart
    { columns: bar_chart_columns, colors: colors }
  end

  def bar_chart_categories
    summary_by_period.map do |keys|
      keys[0][1].strftime('%b')
    end.uniq
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
        range: date_start..date_end
      ).sum(:duration)
  end

  def projects
    user.projects
  end

  private

  def bar_chart_columns
    summary = summary_by_period
    ids = summary.map { |keys| keys[0][0] }.uniq
    ids.map do |id|
      values = summary.select { |keys| keys[0] == id }.values
      [id] + values.map { |value| value / 3600 }
    end
  end

  def colors
    projects.map do |project|
      [project.id, project.color]
    end.to_h
  end
end
