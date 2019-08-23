# frozen_string_literal: true

class Report
  attr_reader :projects

  def initialize(user:, range:, period:, time_zone: nil)
    @projects = user.projects
    @range = range
    @period = period
    @time_zone = time_zone
  end

  def summary
    @projects
      .joins(:activities)
      .group(:id)
      .group_by_period(
        @period, :started_at,
        time_zone: @time_zone,
        permit: %w[hour day month],
        range: @range
      )
      .sum(:duration)
  end
end
