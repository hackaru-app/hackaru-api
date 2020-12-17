# frozen_string_literal: true

class ReportMailer < ApplicationMailer
  def report(user, title, from, to)
    @title = title
    @report = build_report(user, from..to)
    mail(subject: @title, to: user.email)
  end

  private

  def build_report(user, range)
    report = Report.new(
      projects: user.projects,
      start_date: range.begin,
      end_date: range.end,
      time_zone: user.time_zone
    )
    report.valid!
    report
  end
end
