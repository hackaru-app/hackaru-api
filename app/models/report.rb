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
  attribute :projects

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :time_zone, presence: true
  validates_date :start_date, before: :end_date

  def totals
    sums.transform_values(&:sum)
  end

  def sums
    projects.map(&:id).to_h do |id|
      values = group_by_period.select { |keys| keys[0] == id }.values
      values = labels.map { 0 } if values.empty?
      [id, values]
    end
  end

  def labels
    series.map do |date|
      date.strftime(FORMATS[period])
    end
  end

  def colors
    projects.to_h do |project|
      [project.id, project.color]
    end
  end

  def bar_chart_data
    sums.to_a.map(&:flatten)
  end

  def start_date
    super&.in_time_zone(time_zone.presence || 'UTC')
  end

  def end_date
    super&.in_time_zone(time_zone.presence || 'UTC')
  end

  def activity_groups
    ActivityGroup.generate(activities)
  end

  def activities
    Activity.joins(:project)
            .preload(:project)
            .merge(projects)
            .stopped
            .where(started_at: start_date..end_date)
  end

  private

  def series
    dates = [start_date]
    dates << dates.last + 1.send(period) while dates.last <= end_date
    dates.pop
    dates
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
      out_of_date = start_date + 1.send(periods.last)
      return periods.first if end_date < out_of_date
    end || PERIODS.last
  end
end
