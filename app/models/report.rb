# frozen_string_literal: true

class Report
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ValidationRaisable

  FORMATS = {
    hour: '%H',
    day: '%d',
    month: '%b',
    year: '%Y'
  }.freeze

  attribute :start_date, :datetime
  attribute :end_date, :datetime
  attribute :time_zone, :string
  attribute :user

  validates :user, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :time_zone, presence: true
  validates :start_date, date: { before: :end_date }

  def totals
    data.map do |key, value|
      [key, value.sum]
    end.to_h
  end

  def data
    summary = summary_by_period
    projects.map(&:id).map do |id|
      values = summary.select { |keys| keys[0] == id }.values
      values = labels.map { 0 } if values.empty?
      [id, values]
    end.to_h
  end

  def projects
    user.projects
  end

  def labels
    dates = [start_date]
    dates << dates.last + 1.send(period) while dates.last <= end_date
    dates.pop
    dates.map do |date|
      date.strftime(FORMATS[period])
    end
  end

  def colors
    projects.map do |project|
      [project.id, project.color]
    end.to_h
  end

  def bar_chart_data
    data.map do |id, values|
      [id] + values.map { |value| value / 3600 }
    end
  end

  private

  def summary_by_period
    @summary_by_period ||=
      projects
      .joins(:activities)
      .group(:id)
      .group_by_period(
        period,
        :started_at,
        time_zone: time_zone,
        range: start_date..end_date
      ).sum(:duration)
  end

  def period
    duration = end_date - start_date
    return :hour  if duration <= 1.day
    return :day   if duration <= 1.month
    return :month if duration <= 1.year

    :year
  end
end
