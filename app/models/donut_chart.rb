# frozen_string_literal: true

class DonutChart
  def initialize(report)
    @report = report
  end

  def columns
    @report.totals.to_a
  end

  def colors
    @report.projects.map(&:color)
  end
end
