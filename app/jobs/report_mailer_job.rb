# frozen_string_literal: true

class ReportMailerJob < ApplicationJob
  queue_as :low

  def perform(period, today = Date.today)
    range = build_range(period, today)
    target_users(range).each do |user|
      send_mail(user, period, range)
    end
  end

  private

  def build_range(period, today)
    today
      .public_send("prev_#{period}")
      .public_send("all_#{period}")
  end

  def send_mail(user, period, range)
    scope = "jobs.report_mailer_job.#{period}"
    ReportMailer.report(
      user,
      I18n.t(:title, scope: scope),
      range.begin,
      range.end
    ).deliver_later
  end

  def target_users(range)
    User.select do |user|
      user.activities.stopped.where(started_at: range).present?
    end
  end
end
