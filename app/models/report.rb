# frozen_string_literal: true

class Report
  include ActiveModel::Model
  include ActiveModel::Attributes

  FORMATS = {
    hour: '%H',
    day: '%d',
    month: '%b',
    year: '%Y'
  }.freeze

  attribute :user_id, :integer
  attribute :date_start, :datetime
  attribute :date_end, :datetime
  attribute :period, :string
  attribute :time_zone, :string
  attribute :user

  validates :user_id, presence: true
  validates :start, presence: true
  validates :end, presence: true

  def totals
    data.map do |key, value|
      [key, value.sum]
    end.to_h
  end

  # def donut_chart
  #   { columns: summary.to_a, colors: colors }
  # end

  # def bar_chart
  #   { columns: bar_chart_columns, colors: colors }
  # end

  # def bar_chart_categories
  #   summary_by_period.map do |keys|
  #     keys[0][1].strftime('%b')
  #   end.uniq
  # end

  def data
    summary = summary_by_period
    data = projects.map(&:id).map do |id|
      values = summary.select { |keys| keys[0] == id }.values
      values = labels.map { 0 } if values.empty?
      [id, values]
    end.to_h
  end

  def projects
    user.projects
  end

  def labels
    dates = [date_start]
    while dates.last <= date_end
      dates << dates.last + 1.send(period)
    end
    dates.pop
    dates.map do |date|
      date.strftime(FORMATS[period])
    end
  end

  private

  def summary_by_period
    projects
      .joins(:activities)
      .group(:id)
      .group_by_period(
        period,
        :started_at,
        time_zone: time_zone,
        range: date_start..date_end
      ).sum(:duration)
  end

  def period
    duration = date_end - date_start
    return :hour  if duration <= 1.day
    return :day   if duration <= 1.month
    return :month if duration <= 1.year

    :year
  end

  # def bar_chart_columns
  #   summary = summary_by_period
  #   ids = summary.map { |keys| keys[0][0] }.uniq
  #   ids.map do |id|
  #     values = summary.select { |keys| keys[0] == id }.values
  #     [id] + values.map { |value| value / 3600 }
  #   end
  # end

  # def colors
  #   projects.map do |project|
  #     [project.id, project.color]
  #   end.to_h
  # end
end
