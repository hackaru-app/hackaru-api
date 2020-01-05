# frozen_string_literal: true

class ReportMailer < ApplicationMailer
  add_template_helper(DurationHelper)

  def weekly(user)
    range = Date.today.prev_week.all_week
    @report = build_report(user, range)
    subject = I18n.t('report_mailer.weekly.subject', start: range.begin)
    mail(subject: subject, to: user.email)
  end

  private

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
