# frozen_string_literal: true

class ReportMailer < ApplicationMailer
  add_template_helper(DurationHelper)

  def weekly(user)
    @report = build_report(user, Date.today.prev_week.all_week)
    set_show_variables
    subject = I18n.t('report_mailer.weekly.subject')
    mail(subject: subject, to: user.email)
  end

  private

  def set_show_variables
    Gon.global.push(
      bar_chart_data: @report.bar_chart_data,
      totals: @report.totals.to_a,
      groups: @report.projects.map(&:id),
      colors: @report.colors,
      labels: @report.labels
    )
  end

  def build_report(user, range)
    report = Report.new(
      user: user,
      start_date: range.begin,
      end_date: range.end,
      time_zone: 'UTC' # TODO
    )
    report.valid!
    report
  end
end
