# frozen_string_literal: true

class BarChart
  def initialize(report)
    @report = report
  end

  def columns
    @report.data.map do |id, values|
      hours = values.map { |value| value / 3600 }
      [id] + hours
    end
  end

  def colors
    @report.projects.map(&:color)
  end

  def labels
    @report.labels
  end
end
