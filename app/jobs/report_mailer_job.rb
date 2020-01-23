# frozen_string_literal: true

class ReportMailerJob < ApplicationJob
  queue_as :low

  def perform(*args)
    period = args[0]['period']
    target_users(period).each do |user|
      send_mail(user, period)
    end
  end

  private

  def build_range(period)
    args = period == 'week' ? [:sunday] : []
    Date.today
        .public_send("prev_#{period}", *args)
        .public_send("all_#{period}", *args)
  end

  def send_mail(user, period)
    range = build_range(period)
    scope = "jobs.report_mailer_job.#{period}"
    ReportMailer.report(
      user,
      I18n.t(:title, scope: scope),
      range.begin,
      range.end
    ).deliver_later
  end

  def target_users(period)
    range = build_range(period)
    User.where("receive_#{period}_report": true).select do |user|
      user.activities.stopped.where(started_at: range).present?
    end
  end
end
