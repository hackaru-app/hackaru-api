# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/report_mailer
class ReportMailerPreview < ActionMailer::Preview
  def weekly
    title = I18n.t('jobs.report_mailer_job.weekly.title')
    range = Time.zone.local(2017, 1, 1).all_week(:sunday)
    report(title, range.begin, range.end)
  end

  def monthly
    title = I18n.t('jobs.report_mailer_job.monthly.title')
    range = Time.zone.local(2017, 1, 1).all_month
    report(title, range.begin, range.end)
  end

  private

  def report(title, from, to)
    user = FactoryBot.create(:user, time_zone: 'Etc/UTC')
    FactoryBot.create_list(
      :activity, 3,
      user: user,
      started_at: Time.zone.local(2017, 1, 1),
      stopped_at: Time.zone.local(2017, 1, 2)
    )
    ReportMailer.report(user, title, from, to)
  end
end
