# frozen_string_literal: true

class Report
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ValidationRaisable

  PERIODS = %i[
    hour
    day
    month
    year
  ].freeze

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
    sums.map do |key, value|
      [key, value.sum]
    end.to_h
  end

  def sums
    projects.map(&:id).map do |id|
      values = group_by_period.select { |keys| keys[0] == id }.values
      values = labels.map { 0 } if values.empty?
      [id, values]
    end.to_h
  end

  def projects
    user.projects
  end

  def labels
    series.map do |date|
      date.strftime(FORMATS[period])
    end
  end

  def colors
    projects.map do |project|
      [project.id, project.color]
    end.to_h
  end

  def bar_chart_data
    sums.map do |id, values|
      [id] + values.map { |value| value / 3600 }
    end
  end

  private

  def series
    dates = [in_time_zone(start_date)]
    dates << dates.last + 1.send(period) while dates.last <= in_time_zone(end_date)
    dates.pop
    dates
  end

  def in_time_zone(time)
    time.in_time_zone(time_zone)
  end

  def group_by_period
    @group_by_period ||=
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
    PERIODS.each_cons(2) do |periods|
      out_of_date = in_time_zone(start_date) + 1.send(periods.last)
      return periods.first if in_time_zone(end_date) < out_of_date
    end || PERIODS.last
  end
end
