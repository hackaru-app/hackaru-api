# frozen_string_literal: true

class ReportMailerJob < ApplicationJob
  queue_as :low

  def perform(period)
    range = build_range(period)
    target_users(range).each do |user|
      send_mail(user, range)
    end
  end

  private

  def build_range(period)
    Date.today
      .public_send("prev_#{period}")
      .public_send("all_#{period}")
  end

  def send_mail(user, range)
    scope = "jobs.report_mailer_job.#{period}"
    title = I18n.t(:title, scope: scope)
    ReportMailer.report(user, title, range)
  end

  def target_users(range)
    User.select do |user|
      user.activities.between(range.begin, range.end).present?
    end
  end
end
