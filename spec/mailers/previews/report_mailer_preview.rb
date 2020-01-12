# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/report_mailer
class ReportMailerPreview < ActionMailer::Preview
  def weekly
    title = I18n.t('jobs.report_mailer_job.week.title')
    range = Date.today.prev_week.all_week
    report(title, range.begin, range.end)
  end

  def monthly
    title = I18n.t('jobs.report_mailer_job.month.title')
    range = Date.today.prev_month.all_month
    report(title, range.begin, range.end)
  end

  private

  def report(title, from, to)
    user = FactoryBot.create(:user)
    FactoryBot.create_list(
      :activity, 3,
      user: user,
      started_at: from,
      stopped_at: to + 1.hours
    )
    ReportMailer.report(user, title, from, to)
  end
end
