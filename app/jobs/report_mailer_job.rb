# frozen_string_literal: true

class ReportMailerJob < ApplicationJob
  queue_as :low

  def perform(*args)
    period = args[0]['period']
    target_users(period).each do |user|
      I18n.with_locale(user.locale) do
        send_mail(user, period)
      end
    end
  end

  private

  def target_users(period)
    User.where("receive_#{period}_report": true).select do |user|
      range = build_range(user, period)
      user.activities.stopped.where.not(project: nil)
          .where(started_at: range)
          .present?
    end
  end

  def send_mail(user, period)
    ReportMailer.report(
      user,
      I18n.t(:title, scope: "jobs.report_mailer_job.#{period}"),
      build_range(user, period).begin,
      build_range(user, period).end
    ).deliver_later
  end

  def build_range(user, period)
    args = period == 'week' ? [:sunday] : []
    prev = current_time(user.time_zone) - 1.public_send(period)
    prev.public_send("all_#{period}", *args)
  end

  def current_time(time_zone)
    Time.now.asctime.in_time_zone(time_zone)
  end
end
